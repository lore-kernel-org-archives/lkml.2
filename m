Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab1FWWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:25:59 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24219 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1FWWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:25:57 -0400
Date: Fri, 24 Jun 2011 00:17:01 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        ivtv-devel@ivtvdriver.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Luca Risolia <luca.risolia@studio.unibo.it>,
        Olivier Lorin <o.lorin@laposte.net>,
        Jean-Francois Moine <moinejf@free.fr>,
        Huang Shijie <shijie8@gmail.com>, Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 12/37] Remove unneeded version.h includes (and add where
 needed) for drivers/media/video/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240014220.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that linux/version.h was not
always being included where needed and sometimes included needlessly
in drivers/media/video/.
This patch fixes up the includes.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/video/cpia2/cpia2.h            |    1 -
 drivers/media/video/cx18/cx18-driver.h       |    1 -
 drivers/media/video/cx18/cx18-version.h      |    2 ++
 drivers/media/video/cx231xx/cx231xx.h        |    1 +
 drivers/media/video/cx23885/altera-ci.c      |    1 -
 drivers/media/video/davinci/vpif_capture.c   |    1 -
 drivers/media/video/davinci/vpif_capture.h   |    1 -
 drivers/media/video/davinci/vpif_display.c   |    1 -
 drivers/media/video/davinci/vpif_display.h   |    1 -
 drivers/media/video/et61x251/et61x251.h      |    1 -
 drivers/media/video/et61x251/et61x251_core.c |    1 +
 drivers/media/video/gspca/gl860/gl860.h      |    1 -
 drivers/media/video/hdpvr/hdpvr-video.c      |    2 --
 drivers/media/video/hdpvr/hdpvr.h            |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h       |    1 -
 drivers/media/video/ivtv/ivtv-version.h      |    2 ++
 drivers/media/video/m5mols/m5mols_capture.c  |    2 --
 drivers/media/video/m5mols/m5mols_core.c     |    1 -
 drivers/media/video/pwc/pwc-ioctl.h          |    1 -
 drivers/media/video/saa7164/saa7164.h        |    1 -
 drivers/media/video/sn9c102/sn9c102.h        |    1 -
 drivers/media/video/sn9c102/sn9c102_core.c   |    1 +
 drivers/media/video/timblogiw.c              |    1 -
 drivers/media/video/tlg2300/pd-common.h      |    1 -
 drivers/media/video/tlg2300/pd-video.c       |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c           |    1 -
 drivers/media/video/uvc/uvcvideo.h           |    1 +
 27 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/cpia2/cpia2.h b/drivers/media/video/cpia2/cpia2.h
index 6d6d184..5e1faa2 100644
--- a/drivers/media/video/cpia2/cpia2.h
+++ b/drivers/media/video/cpia2/cpia2.h
@@ -31,7 +31,6 @@
 #ifndef __CPIA2_H__
 #define __CPIA2_H__
 
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/usb.h>
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index 0864272..1834207 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -25,7 +25,6 @@
 #ifndef CX18_DRIVER_H
 #define CX18_DRIVER_H
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
diff --git a/drivers/media/video/cx18/cx18-version.h b/drivers/media/video/cx18/cx18-version.h
index cd189b6..bbbd503 100644
--- a/drivers/media/video/cx18/cx18-version.h
+++ b/drivers/media/video/cx18/cx18-version.h
@@ -22,6 +22,8 @@
 #ifndef CX18_VERSION_H
 #define CX18_VERSION_H
 
+#include <linux/version.h>
+
 #define CX18_DRIVER_NAME "cx18"
 #define CX18_DRIVER_VERSION_MAJOR 1
 #define CX18_DRIVER_VERSION_MINOR 5
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 46dd840..c42b7ff 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -22,6 +22,7 @@
 #ifndef _CX231XX_H
 #define _CX231XX_H
 
+#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
diff --git a/drivers/media/video/cx23885/altera-ci.c b/drivers/media/video/cx23885/altera-ci.c
index 678539b..1fa8927 100644
--- a/drivers/media/video/cx23885/altera-ci.c
+++ b/drivers/media/video/cx23885/altera-ci.c
@@ -52,7 +52,6 @@
  * |  DATA7|  DATA6|  DATA5|  DATA4|  DATA3|  DATA2|  DATA1|  DATA0|
  * +-------+-------+-------+-------+-------+-------+-------+-------+
  */
-#include <linux/version.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/videobuf-dvb.h>
 #include "altera-ci.h"
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index d93ad74..dbdd1eb 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -33,7 +33,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index 7a4196d..97e7fd5 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -23,7 +23,6 @@
 
 /* Header files */
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index cdf659a..66b1631 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -29,7 +29,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 
 #include <asm/irq.h>
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index b53aaa8..049a42c 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -18,7 +18,6 @@
 
 /* Header files */
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
diff --git a/drivers/media/video/et61x251/et61x251.h b/drivers/media/video/et61x251/et61x251.h
index bf66189..14bb907 100644
--- a/drivers/media/video/et61x251/et61x251.h
+++ b/drivers/media/video/et61x251/et61x251.h
@@ -21,7 +21,6 @@
 #ifndef _ET61X251_H_
 #define _ET61X251_H_
 
-#include <linux/version.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index a982750..3722711 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -34,6 +34,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/page-flags.h>
+#include <linux/version.h>
 #include <media/v4l2-ioctl.h>
 #include <asm/byteorder.h>
 #include <asm/page.h>
diff --git a/drivers/media/video/gspca/gl860/gl860.h b/drivers/media/video/gspca/gl860/gl860.h
index 49ad4ac..0330a02 100644
--- a/drivers/media/video/gspca/gl860/gl860.h
+++ b/drivers/media/video/gspca/gl860/gl860.h
@@ -18,7 +18,6 @@
  */
 #ifndef GL860_DEV_H
 #define GL860_DEV_H
-#include <linux/version.h>
 
 #include "gspca.h"
 
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 514aea7..79b89a1 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -17,9 +17,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
-
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
index 072f23c..e74ba50 100644
--- a/drivers/media/video/hdpvr/hdpvr.h
+++ b/drivers/media/video/hdpvr/hdpvr.h
@@ -14,7 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/videodev2.h>
-
+#include <linux/version.h>
 #include <media/v4l2-device.h>
 #include <media/ir-kbd-i2c.h>
 
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 84bdf0f..8f9cc17 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -36,7 +36,6 @@
  *                using information provided by Jiun-Kuei Jung @ AVerMedia.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/drivers/media/video/ivtv/ivtv-version.h b/drivers/media/video/ivtv/ivtv-version.h
index b67a404..3767237 100644
--- a/drivers/media/video/ivtv/ivtv-version.h
+++ b/drivers/media/video/ivtv/ivtv-version.h
@@ -20,6 +20,8 @@
 #ifndef IVTV_VERSION_H
 #define IVTV_VERSION_H
 
+#include <linux/version.h>
+
 #define IVTV_DRIVER_NAME "ivtv"
 #define IVTV_DRIVER_VERSION_MAJOR 1
 #define IVTV_DRIVER_VERSION_MINOR 4
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index d71a390..bf704cb 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -18,11 +18,9 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 76eac26..05d086e 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/video/pwc/pwc-ioctl.h b/drivers/media/video/pwc/pwc-ioctl.h
index 8c0cae7..b74fea0 100644
--- a/drivers/media/video/pwc/pwc-ioctl.h
+++ b/drivers/media/video/pwc/pwc-ioctl.h
@@ -52,7 +52,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/version.h>
 
  /* Enumeration of image sizes */
 #define PSZ_SQCIF	0x00
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 16745d2..6678bf1 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -48,7 +48,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/kdev_t.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/crc32.h>
 #include <linux/kthread.h>
diff --git a/drivers/media/video/sn9c102/sn9c102.h b/drivers/media/video/sn9c102/sn9c102.h
index cbfc444..22ea211 100644
--- a/drivers/media/video/sn9c102/sn9c102.h
+++ b/drivers/media/video/sn9c102/sn9c102.h
@@ -21,7 +21,6 @@
 #ifndef _SN9C102_H_
 #define _SN9C102_H_
 
-#include <linux/version.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 0e07c49..8908501 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
  ***************************************************************************/
 
+#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index fc611eb..84cd1b6 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -20,7 +20,6 @@
  * Timberdale FPGA LogiWin Video In
  */
 
-#include <linux/version.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
diff --git a/drivers/media/video/tlg2300/pd-common.h b/drivers/media/video/tlg2300/pd-common.h
index 46066bd..56564e6 100644
--- a/drivers/media/video/tlg2300/pd-common.h
+++ b/drivers/media/video/tlg2300/pd-common.h
@@ -1,7 +1,6 @@
 #ifndef PD_COMMON_H
 #define PD_COMMON_H
 
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/wait.h>
 #include <linux/list.h>
diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index a794ae6..f243ec0 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -5,7 +5,7 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-
+#include <linux/version.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 543a803..7fbd389 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 20107fd..1c0fe5e 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -101,6 +101,7 @@ struct uvc_xu_control {
 #include <linux/usb.h>
 #include <linux/usb/video.h>
 #include <linux/uvcvideo.h>
+#include <linux/version.h>
 #include <media/media-device.h>
 #include <media/v4l2-device.h>
 
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

