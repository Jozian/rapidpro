# Generated by Django 2.2.20 on 2021-06-08 19:13

import django.db.models.deletion
import django.utils.timezone
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ("orgs", "0084_org_deleted_on"),
        ("tickets", "0004_squashed"),
    ]

    operations = [
        migrations.CreateModel(
            name="TicketEvent",
            fields=[
                ("id", models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                (
                    "event_type",
                    models.CharField(choices=[("O", "Opened"), ("N", "Note"), ("C", "Closed")], max_length=1),
                ),
                ("note", models.TextField(null=True)),
                ("created_on", models.DateTimeField(default=django.utils.timezone.now)),
                (
                    "created_by",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.PROTECT, to=settings.AUTH_USER_MODEL, null=True
                    ),
                ),
                (
                    "org",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.PROTECT, related_name="ticket_events", to="orgs.Org"
                    ),
                ),
                (
                    "ticket",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.PROTECT, related_name="events", to="tickets.Ticket"
                    ),
                ),
            ],
        ),
    ]