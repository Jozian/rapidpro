# Generated by Django 4.0.7 on 2022-10-18 06:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("msgs", "0193_alter_msg_failed_reason"),
    ]

    operations = [
        migrations.AddField(
            model_name="broadcast",
            name="is_active",
            field=models.BooleanField(null=True),
        ),
        migrations.AlterField(
            model_name="broadcast",
            name="is_active",
            field=models.BooleanField(default=True, null=True),
        ),
    ]
