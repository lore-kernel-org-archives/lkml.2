Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0FZX1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 19:27:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39997 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0FZX1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 19:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tSCUtVrd4CYA/ChoO5PH9NfT8wAZefoGBDmWblDBD9k4jBeXQsBnfLlx5IVOhAAnS4
         UWkldbYsUAnkMRF3Yp46g4I0jzujcbqAzigcjt8ySG7yVCI3EzWpM4Ra8FYI93GMWyXv
         IFb+gS3pJcfv5YecFXg4fDcloEhGusrVcfGh8=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, martyn.welch@ge.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH 4/4] Staging: vme: devices: fix coding style issues in vme_user.c
Date: Sat, 26 Jun 2010 18:27:27 -0500
Message-Id: <1277594847-19171-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the vme_user.c file that fixes up the following
issues:

WARNING: please, no space before tabs						x 12
ERROR: code indent should use tabs where possible				x 15
WARNING: braces {} are not necessary for single statement blocks		x  2
WARNING: printk() should include KERN_ facility level				x  3
ERROR: "foo * bar" should be "foo *bar"						x  1
ERROR: space required before the open brace '{'					x  3
WARNING: space prohibited between function name and open parenthesis '('	x  1
ERROR: spaces required around that '=' (ctx:VxV)				x  2
ERROR: spaces required around that '<' (ctx:VxV)				x  2
ERROR: space required after that ',' (ctx:VxV)					x  3
ERROR: spaces required around that '?' (ctx:VxW)				x  1
ERROR: space required before the open parenthesis '('				x  1
WARNING: braces {} are not necessary for single statement blocks		x  2


Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/vme/devices/vme_user.c |   89 ++++++++++++++++----------------
 1 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index bc16fc0..7885f81 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -48,19 +48,19 @@ static int bus_num;
 /* Currently Documentation/devices.txt defines the following for VME:
  *
  * 221 char	VME bus
- * 		  0 = /dev/bus/vme/m0		First master image
- * 		  1 = /dev/bus/vme/m1		Second master image
- * 		  2 = /dev/bus/vme/m2		Third master image
- * 		  3 = /dev/bus/vme/m3		Fourth master image
- * 		  4 = /dev/bus/vme/s0		First slave image
- * 		  5 = /dev/bus/vme/s1		Second slave image
- * 		  6 = /dev/bus/vme/s2		Third slave image
- * 		  7 = /dev/bus/vme/s3		Fourth slave image
- * 		  8 = /dev/bus/vme/ctl		Control
+ *		  0 = /dev/bus/vme/m0		First master image
+ *		  1 = /dev/bus/vme/m1		Second master image
+ *		  2 = /dev/bus/vme/m2		Third master image
+ *		  3 = /dev/bus/vme/m3		Fourth master image
+ *		  4 = /dev/bus/vme/s0		First slave image
+ *		  5 = /dev/bus/vme/s1		Second slave image
+ *		  6 = /dev/bus/vme/s2		Third slave image
+ *		  7 = /dev/bus/vme/s3		Fourth slave image
+ *		  8 = /dev/bus/vme/ctl		Control
  *
- * 		It is expected that all VME bus drivers will use the
- * 		same interface.  For interface documentation see
- * 		http://www.vmelinux.org/.
+ *		It is expected that all VME bus drivers will use the
+ *		same interface.  For interface documentation see
+ *		http://www.vmelinux.org/.
  *
  * However the VME driver at http://www.vmelinux.org/ is rather old and doesn't
  * even support the tsi148 chipset (which has 8 master and 8 slave windows).
@@ -137,12 +137,12 @@ static int __init vme_user_probe(struct device *, int, int);
 static int __exit vme_user_remove(struct device *, int, int);
 
 static struct file_operations vme_user_fops = {
-        .open = vme_user_open,
-        .release = vme_user_release,
-        .read = vme_user_read,
-        .write = vme_user_write,
-        .llseek = vme_user_llseek,
-        .unlocked_ioctl = vme_user_unlocked_ioctl,
+		.open = vme_user_open,
+		.release = vme_user_release,
+		.read = vme_user_read,
+		.write = vme_user_write,
+		.llseek = vme_user_llseek,
+		.unlocked_ioctl = vme_user_unlocked_ioctl,
 };
 
 
@@ -151,13 +151,13 @@ static struct file_operations vme_user_fops = {
  */
 static void reset_counters(void)
 {
-        statistics.reads = 0;
-        statistics.writes = 0;
-        statistics.ioctls = 0;
-        statistics.irqs = 0;
-        statistics.berrs = 0;
-        statistics.dmaErrors = 0;
-        statistics.timeouts = 0;
+		statistics.reads = 0;
+		statistics.writes = 0;
+		statistics.ioctls = 0;
+		statistics.irqs = 0;
+		statistics.berrs = 0;
+		statistics.dmaErrors = 0;
+		statistics.timeouts = 0;
 }
 
 static int vme_user_open(struct inode *inode, struct file *file)
@@ -216,21 +216,20 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
 		/* We copy to kernel buffer */
 		copied = vme_master_read(image[minor].resource,
 			image[minor].kern_buf, count, *ppos);
-		if (copied < 0) {
+		if (copied < 0)
 			return (int)copied;
-		}
 
 		retval = __copy_to_user(buf, image[minor].kern_buf,
 			(unsigned long)copied);
 		if (retval != 0) {
 			copied = (copied - retval);
-			printk("User copy failed\n");
+			printk(KERN_ERR "User copy failed\n");
 			return -EINVAL;
 		}
 
 	} else {
 		/* XXX Need to write this */
-		printk("Currently don't support large transfers\n");
+		printk(KERN_ERR "Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_read to do the transfer */
@@ -264,7 +263,7 @@ static ssize_t resource_from_user(unsigned int minor, const char *buf,
 			image[minor].kern_buf, copied, *ppos);
 	} else {
 		/* XXX Need to write this */
-		printk("Currently don't support large transfers\n");
+		printk(KERN_ERR "Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_write to do the transfer */
@@ -313,7 +312,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char *buf,
 }
 
 static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
-			loff_t * ppos)
+			loff_t *ppos)
 {
 	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
 	ssize_t retval;
@@ -337,7 +336,7 @@ static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
 	else
 		okcount = count;
 
-	switch (type[minor]){
+	switch (type[minor]) {
 	case MASTER_MINOR:
 		retval = resource_to_user(minor, buf, okcount, ppos);
 		break;
@@ -380,7 +379,7 @@ static ssize_t vme_user_write(struct file *file, const char *buf, size_t count,
 	else
 		okcount = count;
 
-	switch (type[minor]){
+	switch (type[minor]) {
 	case MASTER_MINOR:
 		retval = resource_from_user(minor, buf, okcount, ppos);
 		break;
@@ -571,7 +570,7 @@ vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 /*
  * Unallocate a previously allocated buffer
  */
-static void buf_unalloc (int num)
+static void buf_unalloc(int num)
 {
 	if (image[num].kern_buf) {
 #ifdef VME_DEBUG
@@ -594,9 +593,9 @@ static void buf_unalloc (int num)
 }
 
 static struct vme_driver vme_user_driver = {
-        .name = driver_name,
-        .probe = vme_user_probe,
-	.remove = vme_user_remove,
+		.name = driver_name,
+		.probe = vme_user_probe,
+		.remove = vme_user_remove,
 };
 
 
@@ -770,16 +769,16 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 	}
 
 	/* Add sysfs Entries */
-	for (i=0; i<VME_DEVS; i++) {
+	for (i = 0; i < VME_DEVS; i++) {
 		switch (type[i]) {
 		case MASTER_MINOR:
-			sprintf(name,"bus/vme/m%%d");
+			sprintf(name, "bus/vme/m%%d");
 			break;
 		case CONTROL_MINOR:
-			sprintf(name,"bus/vme/ctl");
+			sprintf(name, "bus/vme/ctl");
 			break;
 		case SLAVE_MINOR:
-			sprintf(name,"bus/vme/s%%d");
+			sprintf(name, "bus/vme/s%%d");
 			break;
 		default:
 			err = -EINVAL;
@@ -792,7 +791,7 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 				MKDEV(VME_MAJOR, i), NULL, name,
 				(type[i] == SLAVE_MINOR)? i - (MASTER_MAX + 1) : i);
 		if (IS_ERR(image[i].device)) {
-			printk("%s: Error creating sysfs device\n",
+			printk(KERN_ERR "%s: Error creating sysfs device\n",
 				driver_name);
 			err = PTR_ERR(image[i].device);
 			goto err_sysfs;
@@ -804,7 +803,7 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 	/* Ensure counter set correcty to destroy all sysfs devices */
 	i = VME_DEVS;
 err_sysfs:
-	while (i > 0){
+	while (i > 0) {
 		i--;
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
 	}
@@ -845,9 +844,9 @@ static int __exit vme_user_remove(struct device *dev, int cur_bus, int cur_slot)
 	int i;
 
 	/* Remove sysfs Entries */
-	for(i=0; i<VME_DEVS; i++) {
+	for (i = 0; i < VME_DEVS; i++)
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
-	}
+
 	class_destroy(vme_user_sysfs_class);
 
 	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
-- 
1.7.1

