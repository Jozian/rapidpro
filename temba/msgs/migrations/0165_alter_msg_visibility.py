# Generated by Django 4.0.2 on 2022-02-10 16:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("msgs", "0164_alter_exportmessagestask_created_by_and_more"),
    ]

    operations = [
        migrations.AlterField(
            model_name="msg",
            name="visibility",
            field=models.CharField(
                choices=[("V", "Visible"), ("A", "Archived"), ("D", "Deleted by user"), ("X", "Deleted by sender")],
                default="V",
                max_length=1,
            ),
        ),
    ]