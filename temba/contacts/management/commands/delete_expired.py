# A management command that deletes contacts older than a certain date.

from django.core.management.base import BaseCommand, CommandError

from temba.contacts.models import Contact
from temba.orgs.models import Org
from django.utils import timezone
from django.contrib.auth import get_user_model

User = get_user_model()


class Command(BaseCommand):  # pragma: no cover
    help = "Deletes contacts last seen on before a certain date"

    def add_arguments(self, parser):
        parser.add_argument(
            "date",
            help="The date to delete contacts who were last seen before (deletes older than beginning of day))",
            type=lambda d: timezone.datetime.strptime(d, "%Y-%m-%d"),
        )
        parser.add_argument(
            "org", help="The org to delete contacts for", type=int 
        )

    def handle(self, *args, **options):
        org = Org.objects.filter(pk=options["org"]).first()
        tz = timezone.get_current_timezone()
        date = tz.localize(options["date"])
        if not org:
            raise CommandError("No such org: %s" % options["org"])
        contacts = Contact.objects.filter(
            org=org, last_seen_on__lt=date, is_active=True
        )
        print("Deleting %d contacts" % contacts.count())
        # Ask the user if they want to continue
        if input("Are you sure you want to delete these contacts? (y/n): ") != "y":
            print("Aborting")
            return
        
        # Release the contacts
        user = User.objects.filter(username="AnonymousUser").first()
        for contact in contacts:
            print(f"Releasing contact id: {contact.id}")
            contact.release(user)
        print("Full deletion may take a moment, it depends on the celery worker. Make sure the celery worker is running.")


