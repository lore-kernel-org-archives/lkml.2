Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab1FUEGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 00:06:08 -0400
Received: from karen.lavabit.com ([72.249.41.33]:33081 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab1FUEGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 00:06:05 -0400
X-Greylist: delayed 2123 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jun 2011 00:06:05 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=lavabit; d=lavabit.com;
  b=6ZVej1uxOgBhagpIKjhTYCyib2syojlnLL1o/d4KofgxjIglynBfMaMP5U3bbZgw014v/lOTVLoN64riGWfuz/C7L7gTPACkOfegUu7ryc0JUTGlD695QEygujQpWLqJwSTBfZQDjtm7mydLIHW+L6IVYSB+gITnKPDG2sj8Re0=;
  h=Date:From:To:Cc:Subject:Message-Id:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
Date: Mon, 20 Jun 2011 20:29:44 -0700
From: Isaac Dunham <idunham@lavabit.com>
To: <linux-kernel@vger.kernel.org>
Cc: <trivial@kernel.org>
Subject: [PATCH] Update docs to reflect numbering changes
Message-Id: <20110620202944.7bd6e5e1.idunham@lavabit.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch against 3.0 git commit ef46222e7b56e728e423527d430cb2013c595491
changes "2.6.4x" kernel versions to 3.x (2.6.4[0-2] -> 3.[0-2]).

Signed-off-by: Isaac Dunham <idunham@lavabit.com>

diff --git a/Documentation/ABI/removed/o2cb b/Documentation/ABI/removed/o2cb
index 7f5daa4..20c91ad 100644
--- a/Documentation/ABI/removed/o2cb
+++ b/Documentation/ABI/removed/o2cb
@@ -1,6 +1,6 @@
 What:		/sys/o2cb symlink
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	ocfs2-devel@oss.oracle.com
 Description:	This is a symlink: /sys/o2cb to /sys/fs/o2cb. The symlink is
 		removed when new versions of ocfs2-tools which know to look
diff --git a/Documentation/ABI/testing/sysfs-bus-bcma b/Documentation/ABI/testing/sysfs-bus-bcma
index 06b62ba..721b4ae 100644
--- a/Documentation/ABI/testing/sysfs-bus-bcma
+++ b/Documentation/ABI/testing/sysfs-bus-bcma
@@ -1,6 +1,6 @@
 What:		/sys/bus/bcma/devices/.../manuf
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafał Miłecki <zajec5@gmail.com>
 Description:
 		Each BCMA core has it's manufacturer id. See
@@ -8,7 +8,7 @@ Description:
 
 What:		/sys/bus/bcma/devices/.../id
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafał Miłecki <zajec5@gmail.com>
 Description:
 		There are a few types of BCMA cores, they can be identified by
@@ -16,7 +16,7 @@ Description:
 
 What:		/sys/bus/bcma/devices/.../rev
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafał Miłecki <zajec5@gmail.com>
 Description:
 		BCMA cores of the same type can still slightly differ depending
@@ -24,7 +24,7 @@ Description:
 
 What:		/sys/bus/bcma/devices/.../class
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafał Miłecki <zajec5@gmail.com>
 Description:
 		Each BCMA core is identified by few fields, including class it
diff --git a/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870 b/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
index aa11dbd..592f9d8 100644
--- a/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
+++ b/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
@@ -5,7 +5,7 @@ What:		/sys/class/backlight/<backlight>/l3_office_max
 What:		/sys/class/backlight/<backlight>/l4_indoor_max
 What:		/sys/class/backlight/<backlight>/l5_dark_max
 Date:		Mai 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	device-drivers-devel@blackfin.uclinux.org
 Description:
 		Control the maximum brightness for <ambient light zone>
@@ -19,7 +19,7 @@ What:		/sys/class/backlight/<backlight>/l3_office_dim
 What:		/sys/class/backlight/<backlight>/l4_indoor_dim
 What:		/sys/class/backlight/<backlight>/l5_dark_dim
 Date:		Mai 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	device-drivers-devel@blackfin.uclinux.org
 Description:
 		Control the dim brightness for <ambient light zone>
@@ -30,7 +30,7 @@ Description:
 
 What:		/sys/class/backlight/<backlight>/ambient_light_level
 Date:		Mai 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	device-drivers-devel@blackfin.uclinux.org
 Description:
 		Get conversion value of the light sensor.
@@ -40,7 +40,7 @@ Description:
 
 What:		/sys/class/backlight/<backlight>/ambient_light_zone
 Date:		Mai 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	device-drivers-devel@blackfin.uclinux.org
 Description:
 		Get/Set current ambient light zone. Reading returns
diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 4823577..6262cd3 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -43,9 +43,9 @@ detail later on).
 
 The merge window lasts for approximately two weeks.  At the end of this
 time, Linus Torvalds will declare that the window is closed and release the
-first of the "rc" kernels.  For the kernel which is destined to be 2.6.40,
+first of the "rc" kernels.  For the kernel which is destined to be 3.0,
 for example, the release which happens at the end of the merge window will
-be called 2.6.40-rc1.  The -rc1 release is the signal that the time to
+be called 3.0-rc1.  The -rc1 release is the signal that the time to
 merge new features has passed, and that the time to stabilize the next
 kernel has begun.
 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 72e2384..51fa108 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -199,7 +199,7 @@ Files:	drivers/staging/cs5535_gpio/*
 Check:	drivers/staging/cs5535_gpio/cs5535_gpio.c
 Why:	A newer driver replaces this; it is drivers/gpio/cs5535-gpio.c, and
 	integrates with the Linux GPIO subsystem.  The old driver has been
-	moved to staging, and will be removed altogether around 2.6.40.
+	moved to staging, and will be removed altogether around 3.0.
 	Please test the new driver, and ensure that the functionality you
 	need and any bugfixes from the old driver are available in the new
 	one.
@@ -430,7 +430,7 @@ Who:	Avi Kivity <avi@redhat.com>
 ----------------------------
 
 What:	iwlwifi 50XX module parameters
-When:	2.6.40
+When:	3.0
 Why:	The "..50" modules parameters were used to configure 5000 series and
 	up devices; different set of module parameters also available for 4965
 	with same functionalities. Consolidate both set into single place
@@ -441,7 +441,7 @@ Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
 ----------------------------
 
 What:	iwl4965 alias support
-When:	2.6.40
+When:	3.0
 Why:	Internal alias support has been present in module-init-tools for some
 	time, the MODULE_ALIAS("iwl4965") boilerplate aliases can be removed
 	with no impact.
@@ -482,7 +482,7 @@ Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 ----------------------------
 
 What:	iwlwifi disable_hw_scan module parameters
-When:	2.6.40
+When:	3.0
 Why:	Hareware scan is the prefer method for iwlwifi devices for
 	scanning operation. Remove software scan support for all the
 	iwlwifi devices.
@@ -493,7 +493,7 @@ Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
 
 What:   access to nfsd auth cache through sys_nfsservctl or '.' files
         in the 'nfsd' filesystem.
-When:   2.6.40
+When:   3.0
 Why:    This is a legacy interface which have been replaced by a more
         dynamic cache.  Continuing to maintain this interface is an
         unnecessary burden.
@@ -529,7 +529,7 @@ Files:	net/netfilter/xt_connlimit.c
 ----------------------------
 
 What:	noswapaccount kernel command line parameter
-When:	2.6.40
+When:	3.0
 Why:	The original implementation of memsw feature enabled by
 	CONFIG_CGROUP_MEM_RES_CTLR_SWAP could be disabled by the noswapaccount
 	kernel parameter (introduced in 2.6.29-rc1). Later on, this decision
@@ -562,7 +562,7 @@ Who:	Jean Delvare <khali@linux-fr.org>
 ----------------------------
 
 What:	Support for UVCIOC_CTRL_ADD in the uvcvideo driver
-When:	2.6.42
+When:	3.2
 Why:	The information passed to the driver by this ioctl is now queried
 	dynamically from the device.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
@@ -570,7 +570,7 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 ----------------------------
 
 What:	Support for UVCIOC_CTRL_MAP_OLD in the uvcvideo driver
-When:	2.6.42
+When:	3.2
 Why:	Used only by applications compiled against older driver versions.
 	Superseded by UVCIOC_CTRL_MAP which supports V4L2 menu controls.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
@@ -578,7 +578,7 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 ----------------------------
 
 What:	Support for UVCIOC_CTRL_GET and UVCIOC_CTRL_SET in the uvcvideo driver
-When:	2.6.42
+When:	3.2
 Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
index 675612f..5dd960d 100644
--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.txt
@@ -599,7 +599,7 @@ num_unsol_na
 	affect only the active-backup mode.  These options were added for
 	bonding versions 3.3.0 and 3.4.0 respectively.
 
-	From Linux 2.6.40 and bonding version 3.7.1, these notifications
+	From Linux 3.0 and bonding version 3.7.1, these notifications
 	are generated by the ipv4 and ipv6 code and the numbers of
 	repetitions cannot be set independently.
 
diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
index 96d87b6..af9db79 100644
--- a/Documentation/trace/events-power.txt
+++ b/Documentation/trace/events-power.txt
@@ -48,7 +48,7 @@ A new Kconfig option CONFIG_EVENT_POWER_TRACING_DEPRECATED with the default valu
 'y' has been created. This allows the legacy trace power API to be used conjointly
 with the new trace API.
 The Kconfig option, the old trace API (in include/trace/events/power.h) and the
-old trace points will disappear in a future release (namely 2.6.41).
+old trace points will disappear in a future release (namely 3.1).
 
 power_start		"type=%lu state=%lu cpu_id=%lu"
 power_frequency		"type=%lu state=%lu cpu_id=%lu"
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 543a803..42c135d 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -546,7 +546,7 @@ static void uvc_v4l2_ioctl_warn(void)
 		return;
 
 	uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} "
-		   "ioctls will be removed in 2.6.42.\n");
+		   "ioctls will be removed in 3.2.\n");
 	uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/upgrade/ "
 		   "for upgrade instructions.\n");
 	warned = 1;
@@ -1034,7 +1034,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	/* Dynamic controls. UVCIOC_CTRL_ADD, UVCIOC_CTRL_MAP_OLD,
 	 * UVCIOC_CTRL_GET and UVCIOC_CTRL_SET are deprecated and scheduled for
-	 * removal in 2.6.42.
+	 * removal in 3.2.
 	 */
 	case __UVCIOC_CTRL_ADD:
 		uvc_v4l2_ioctl_warn();
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 20107fd..faff500 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -7,7 +7,7 @@
 #ifndef __KERNEL__
 /*
  * This header provides binary compatibility with applications using the private
- * uvcvideo API. This API is deprecated and will be removed in 2.6.42.
+ * uvcvideo API. This API is deprecated and will be removed in 3.2.
  * Applications should be recompiled against the public linux/uvcvideo.h header.
  */
 #warn "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instead."
diff --git a/drivers/staging/cs5535_gpio/TODO b/drivers/staging/cs5535_gpio/TODO
index 98d1cd1..b40f2b1 100644
--- a/drivers/staging/cs5535_gpio/TODO
+++ b/drivers/staging/cs5535_gpio/TODO
@@ -3,4 +3,4 @@ It has been replaced by a driver that makes use of the Linux GPIO subsystem.
 Please switch to that driver, and let dilinger@queued.net know if there's
 anything missing from the new driver.
 
-This driver is scheduled for removal in 2.6.40.
+This driver is scheduled for removal in 3.0.
diff --git a/drivers/staging/generic_serial/TODO b/drivers/staging/generic_serial/TODO
index 8875645..ea16dbd 100644
--- a/drivers/staging/generic_serial/TODO
+++ b/drivers/staging/generic_serial/TODO
@@ -3,4 +3,4 @@ or work if they do build, or if they seem to work, are for obsolete
 hardware, or are full of unfixable races and no one uses them anymore.
 
 If no one steps up to adopt any of these drivers, they will be removed
-in the 2.6.41 release.
+in the 3.1 release.
diff --git a/drivers/staging/tty/TODO b/drivers/staging/tty/TODO
index 8875645..ea16dbd 100644
--- a/drivers/staging/tty/TODO
+++ b/drivers/staging/tty/TODO
@@ -3,4 +3,4 @@ or work if they do build, or if they seem to work, are for obsolete
 hardware, or are full of unfixable races and no one uses them anymore.
 
 If no one steps up to adopt any of these drivers, they will be removed
-in the 2.6.41 release.
+in the 3.1 release.
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 18b3e89..525abbe 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -35,7 +35,7 @@ config NFSD_DEPRECATED
 	help
 	  The syscall interface to nfsd was obsoleted in 2.6.0 by a new
 	  filesystem based interface.  The old interface is due for removal
-	  in 2.6.40.  If you wish to remove the interface before then
+	  in 3.0.  If you wish to remove the interface before then
 	  say N.
 
 	  In unsure, say Y.
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 1f5eae4..25e9366 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -134,7 +134,7 @@ static ssize_t nfsctl_transaction_read(struct file *file, char __user *buf, size
 	if (file->f_dentry->d_name.name[0] == '.' && !warned) {
 		printk(KERN_INFO
 		       "Warning: \"%s\" uses deprecated NFSD interface: %s."
-		       "  This will be removed in 2.6.40\n",
+		       "  This will be removed in 3.0\n",
 		       current->comm, file->f_dentry->d_name.name);
 		warned = 1;
 	}
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 1bcc2a8..b262699 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -65,7 +65,7 @@ TRACE_EVENT(machine_suspend,
 	TP_printk("state=%lu", (unsigned long)__entry->state)
 );
 
-/* This code will be removed after deprecation time exceeded (2.6.41) */
+/* This code will be removed after deprecation time exceeded (3.1) */
 #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
 
 /*
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2ad39e5..cd31345 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -82,7 +82,7 @@ config EVENT_POWER_TRACING_DEPRECATED
 	  power:power_frequency
 	  This is for userspace compatibility
 	  and will vanish after 5 kernel iterations,
-	  namely 2.6.41.
+	  namely 3.1.
 
 config CONTEXT_SWITCH_TRACER
 	bool


-- 
Isaac Dunham <idunham@lavabit.com>

