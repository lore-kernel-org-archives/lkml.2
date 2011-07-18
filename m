Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1GRRiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:38:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64037 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab1GRRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:38:45 -0400
Message-ID: <4e246fa2.c7cde30a.3423.5570@mx.google.com>
From: Angus Hammond <angusgh@gmail.com>
Date: Mon, 18 Jul 2011 18:14:20 +0100
Subject: [PATCH] Fixed coding style in drivers/acpi/ac.c
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed lines causing errors from  scrips/checkpatch.pl.
---
 drivers/acpi/ac.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 58c3f74..e510828 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -1,5 +1,5 @@
 /*
- *  acpi_ac.c - ACPI AC Adapter Driver ($Revision: 27 $)
+ *  acpi_ac.c - ACPI AC Adapter Driver
  *
  *  Copyright (C) 2001, 2002 Andy Grover <andrew.grover@intel.com>
  *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
@@ -54,8 +54,8 @@ MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
-extern struct proc_dir_entry *acpi_lock_ac_dir(void);
-extern void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
+struct proc_dir_entry *acpi_lock_ac_dir(void);
+void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
 static int acpi_ac_open_fs(struct inode *inode, struct file *file);
 #endif
 
@@ -85,7 +85,7 @@ static struct acpi_driver acpi_ac_driver = {
 
 struct acpi_ac {
 	struct power_supply charger;
-	struct acpi_device * device;
+	struct acpi_device *device;
 	unsigned long long state;
 };
 
@@ -102,7 +102,7 @@ static const struct file_operations acpi_ac_fops = {
 #endif
 
 /* --------------------------------------------------------------------------
-                               AC Adapter Management
+				AC Adapter Management
    -------------------------------------------------------------------------- */
 
 static int acpi_ac_get_state(struct acpi_ac *ac)
@@ -124,7 +124,7 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 }
 
 /* --------------------------------------------------------------------------
-                            sysfs I/F
+				sysfs I/F
    -------------------------------------------------------------------------- */
 static int get_ac_property(struct power_supply *psy,
 			   enum power_supply_property psp,
@@ -154,7 +154,7 @@ static enum power_supply_property ac_props[] = {
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
 /* --------------------------------------------------------------------------
-                              FS Interface (/proc)
+				FS Interface (/proc)
    -------------------------------------------------------------------------- */
 
 static struct proc_dir_entry *acpi_ac_dir;
@@ -230,7 +230,7 @@ static int acpi_ac_remove_fs(struct acpi_device *device)
 #endif
 
 /* --------------------------------------------------------------------------
-                                   Driver Model
+				Driver Model
    -------------------------------------------------------------------------- */
 
 static void acpi_ac_notify(struct acpi_device *device, u32 event)
@@ -298,7 +298,7 @@ static int acpi_ac_add(struct acpi_device *device)
 	       acpi_device_name(device), acpi_device_bid(device),
 	       ac->state ? "on-line" : "off-line");
 
-      end:
+end:
 	if (result) {
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_ac_remove_fs(device);
-- 
1.7.4.1

