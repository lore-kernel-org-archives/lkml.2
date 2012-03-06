Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030856Ab2CFOza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:55:30 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46231 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030846Ab2CFOzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:55:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of justinmattock@gmail.com designates 10.68.193.170 as permitted sender) smtp.mail=justinmattock@gmail.com; dkim=pass header.i=justinmattock@gmail.com
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, marauder@tiscali.it,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH V2]NEXT:drivers:staging:media Fix comments and some typos in staging/media/*
Date: Tue,  6 Mar 2012 06:55:09 -0800
Message-Id: <1331045709-19309-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

linux-next:
I like to spend some time reading code, in doing so I have found some typos in some of the comments.
The patch below fixes what I have found.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/media/Kconfig              |    2 +-
 drivers/staging/media/as102/as102_drv.c    |    2 +-
 drivers/staging/media/as102/as102_fe.c     |    4 ++--
 drivers/staging/media/go7007/go7007-v4l2.c |    8 ++++----
 drivers/staging/media/lirc/lirc_serial.c   |    2 +-
 drivers/staging/media/solo6x10/Kconfig     |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 7e5caa3..4f4b7d6 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -6,7 +6,7 @@ menuconfig STAGING_MEDIA
 	  don't have the "normal" Linux kernel quality level.
 	  Most of them don't follow properly the V4L, DVB and/or RC API's,
 	  so, they won't likely work fine with the existing applications.
-	  That also means that, one fixed, their API's will change to match
+	  That also means that, once fixed, their API's will change to match
 	  the existing ones.
 
           If you wish to work on these drivers, to help improve them, or
diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index aae0505..ea4f992 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -27,7 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 
-/* header file for Usb device driver*/
+/* header file for usb device driver*/
 #include "as102_drv.h"
 #include "as102_fw.h"
 #include "dvbdev.h"
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index bdc5a38..57daa8c 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -337,7 +337,7 @@ int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
 	strncpy(dvb_fe->ops.info.name, as102_dev->name,
 		sizeof(dvb_fe->ops.info.name));
 
-	/* register dbvb frontend */
+	/* register dvb frontend */
 	errno = dvb_register_frontend(dvb_adap, dvb_fe);
 	if (errno == 0)
 		dvb_fe->tuner_priv = as102_dev;
@@ -349,7 +349,7 @@ static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *fe_tps,
 					 struct as10x_tps *as10x_tps)
 {
 
-	/* extract consteallation */
+	/* extract constellation */
 	switch (as10x_tps->modulation) {
 	case CONST_QPSK:
 		fe_tps->modulation = QPSK;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 2b27d8d..f916586 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1050,15 +1050,15 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 	return 0;
 }
 
-/* VIDIOC_ENUMSTD on go7007 were used for enumberating the supported fps and
+/* VIDIOC_ENUMSTD on go7007 were used for enumerating the supported fps and
    its resolution, when the device is not connected to TV.
-   This were an API abuse, probably used by the lack of specific IOCTL's to
-   enumberate it, by the time the driver were written.
+   This is were an API abuse, probably used by the lack of specific IOCTL's to
+   enumerate it, by the time the driver was written.
 
    However, since kernel 2.6.19, two new ioctls (VIDIOC_ENUM_FRAMEINTERVALS
    and VIDIOC_ENUM_FRAMESIZES) were added for this purpose.
 
-   The two functions bellow implements the newer ioctls
+   The two functions below implement the newer ioctls
 */
 static int vidioc_enum_framesizes(struct file *filp, void *priv,
 				  struct v4l2_frmsizeenum *fsize)
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 8dd8897..97352cf 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1282,7 +1282,7 @@ MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O"
 /*
  * some architectures (e.g. intel xscale) align the 8bit serial registers
  * on 32bit word boundaries.
- * See linux-kernel/serial/8250.c serial_in()/out()
+ * See linux-kernel/drivers/tty/serial/8250/8250.c serial_in()/out()
  */
 module_param(ioshift, int, S_IRUGO);
 MODULE_PARM_DESC(ioshift, "shift I/O register offset (0 = no shift)");
diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
index 03dcac4..63352de 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -5,4 +5,4 @@ config SOLO6X10
 	select SND_PCM
 	---help---
 	  This driver supports the Softlogic based MPEG-4 and h.264 codec
-	  codec cards.
+	  cards.
-- 
1.7.5.4

