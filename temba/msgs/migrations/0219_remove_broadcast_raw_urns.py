# Generated by Django 4.0.9 on 2023-02-16 15:50

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("msgs", "0218_broadcast_urns"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="broadcast",
            name="raw_urns",
        ),
    ]