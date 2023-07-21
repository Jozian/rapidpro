# Generated by Django 4.2.2 on 2023-07-12 18:23

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("channels", "0167_drop_dup_index"),
    ]

    operations = [
        migrations.AddField(
            model_name="channel",
            name="log_policy",
            field=models.CharField(
                choices=[("N", "Discard All"), ("E", "Write Errors Only"), ("A", "Write All")],
                default="A",
                max_length=1,
            ),
        ),
    ]
