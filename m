Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1C1Qee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:34:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1C1QaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F80R+gAtLipv1v0D+p1wIMCxTzeQC/5QBgYDr/5nPhZ9/CDaZBoUblKtw3tCW754i8
         E2nLWzAfW8BdfE6xZEiW7Oe4TG20rDtrWoSd6R26BpUXwiNIZwgZDdKeQFImQEHkozkT
         W/RlKfWQETNDgOkiCqmPtZ1Ig4arXi1+xQ9AI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/25]drivers:media Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:32 -0700
Message-Id: <1301329788-3423-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/dvb/siano/smscoreapi.h            |    1 -
 drivers/media/radio/radio-cadet.c               |    1 -
 drivers/media/radio/radio-sf16fmi.c             |    1 -
 drivers/media/radio/radio-timb.c                |    1 -
 drivers/media/radio/si470x/radio-si470x.h       |    1 -
 drivers/media/radio/wl128x/fmdrv.h              |    1 -
 drivers/media/video/arv.c                       |    1 -
 drivers/media/video/au0828/au0828-video.c       |    1 -
 drivers/media/video/bt8xx/bttvp.h               |    1 -
 drivers/media/video/bw-qcam.c                   |    1 -
 drivers/media/video/c-qcam.c                    |    1 -
 drivers/media/video/cpia2/cpia2.h               |    1 -
 drivers/media/video/cpia2/cpia2_v4l.c           |    3 ---
 drivers/media/video/cx18/cx18-driver.h          |    1 -
 drivers/media/video/cx231xx/cx231xx-video.c     |    1 -
 drivers/media/video/cx23885/altera-ci.c         |    1 -
 drivers/media/video/cx23885/cx23885.h           |    1 -
 drivers/media/video/cx88/cx88.h                 |    1 -
 drivers/media/video/davinci/vpif_capture.c      |    1 -
 drivers/media/video/davinci/vpif_capture.h      |    1 -
 drivers/media/video/davinci/vpif_display.c      |    1 -
 drivers/media/video/davinci/vpif_display.h      |    1 -
 drivers/media/video/em28xx/em28xx-video.c       |    1 -
 drivers/media/video/et61x251/et61x251.h         |    1 -
 drivers/media/video/fsl-viu.c                   |    1 -
 drivers/media/video/gspca/gl860/gl860.h         |    1 -
 drivers/media/video/gspca/gspca.c               |    1 -
 drivers/media/video/hdpvr/hdpvr-video.c         |    1 -
 drivers/media/video/ivtv/ivtv-driver.h          |    1 -
 drivers/media/video/mem2mem_testdev.c           |    1 -
 drivers/media/video/mx1_camera.c                |    1 -
 drivers/media/video/mx2_camera.c                |    1 -
 drivers/media/video/mx3_camera.c                |    1 -
 drivers/media/video/omap1_camera.c              |    1 -
 drivers/media/video/omap24xxcam.c               |    1 -
 drivers/media/video/omap3isp/ispvideo.h         |    1 -
 drivers/media/video/pms.c                       |    1 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c      |    1 -
 drivers/media/video/pwc/pwc-ioctl.h             |    1 -
 drivers/media/video/pwc/pwc.h                   |    1 -
 drivers/media/video/pxa_camera.c                |    1 -
 drivers/media/video/s2255drv.c                  |    1 -
 drivers/media/video/s5p-fimc/fimc-capture.c     |    1 -
 drivers/media/video/s5p-fimc/fimc-core.c        |    1 -
 drivers/media/video/saa7134/saa7134.h           |    1 -
 drivers/media/video/saa7164/saa7164.h           |    1 -
 drivers/media/video/sh_mobile_ceu_camera.c      |    1 -
 drivers/media/video/sh_vou.c                    |    1 -
 drivers/media/video/sn9c102/sn9c102.h           |    1 -
 drivers/media/video/timblogiw.c                 |    1 -
 drivers/media/video/tlg2300/pd-common.h         |    1 -
 drivers/media/video/tlg2300/pd-radio.c          |    1 -
 drivers/media/video/usbvision/usbvision-video.c |    1 -
 drivers/media/video/uvc/uvc_v4l2.c              |    1 -
 drivers/media/video/vino.c                      |    1 -
 drivers/media/video/vivi.c                      |    1 -
 drivers/media/video/w9966.c                     |    1 -
 drivers/media/video/zoran/zoran_driver.c        |    1 -
 drivers/media/video/zr364xx.c                   |    1 -
 59 files changed, 0 insertions(+), 61 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.h b/drivers/media/dvb/siano/smscoreapi.h
index 8ecadec..c592ae0 100644
--- a/drivers/media/dvb/siano/smscoreapi.h
+++ b/drivers/media/dvb/siano/smscoreapi.h
@@ -22,7 +22,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #ifndef __SMS_CORE_API_H__
 #define __SMS_CORE_API_H__
 
-#include <linux/version.h>
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/mm.h>
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index bc9ad08..6d3e0bb 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -30,7 +30,6 @@
  *		Changed API to V4L2
  */
 
-#include <linux/version.h>
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index b5a5f89..c0455a0 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -16,7 +16,6 @@
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>	/* __setup			*/
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 1e3a8dd..9531e58 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -16,7 +16,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/version.h>
 #include <linux/io.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 4a4e908..beb1d8b 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -32,7 +32,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/input.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index 5db6fd1..a28883a 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -28,7 +28,6 @@
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index f989f28..cf1201f 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 6ad83a1..8c532ef 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -33,7 +33,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 9b776fa..9dde700 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -25,7 +25,6 @@
 #ifndef _BTTVP_H_
 #define _BTTVP_H_
 
-#include <linux/version.h>
 #define BTTV_VERSION_CODE KERNEL_VERSION(0,9,18)
 
 #include <linux/types.h>
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index c119350..a93d5e0 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -71,7 +71,6 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <linux/mm.h>
 #include <linux/parport.h>
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
index 24fc009..ac34de4 100644
--- a/drivers/media/video/c-qcam.c
+++ b/drivers/media/video/c-qcam.c
@@ -35,7 +35,6 @@
 #include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <asm/uaccess.h>
 #include <media/v4l2-device.h>
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
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 5111bbc..eb81c7f 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -29,9 +29,6 @@
  *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  ****************************************************************************/
 
-#include <linux/version.h>
-
-
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/sched.h>
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index b86a740..634ac9e 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -25,7 +25,6 @@
 #ifndef CX18_DRIVER_H
 #define CX18_DRIVER_H
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index ffd5af9..e58078d 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -29,7 +29,6 @@
 #include <linux/bitmap.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
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
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 8db2797..bd7e571 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -36,7 +36,6 @@
 #include "cx23885-reg.h"
 #include "media/cx2341x.h"
 
-#include <linux/version.h>
 #include <linux/mutex.h>
 
 #define CX23885_VERSION_CODE KERNEL_VERSION(0, 0, 2)
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 9b3742a..6aebfe8 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -39,7 +39,6 @@
 #include "cx88-reg.h"
 #include "tuner-xc2028.h"
 
-#include <linux/version.h>
 #include <linux/mutex.h>
 #define CX88_VERSION_CODE KERNEL_VERSION(0, 0, 8)
 
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
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index a83131b..0815851 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -32,7 +32,6 @@
 #include <linux/bitmap.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
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
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 031af16..ebf2a85 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -23,7 +23,6 @@
 #include <linux/io.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
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
 
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 9c6a643..c24be65 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -24,7 +24,6 @@
 #define MODULE_NAME "gspca"
 
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 514aea7..ca46fb2 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -17,7 +17,6 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 
 #include <linux/videodev2.h>
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
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index b03d74e..c7919ec 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index bc0c23a..3733500 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -31,7 +31,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 4eab1c6..1792835 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -23,7 +23,6 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 502e2a4..903f360 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -11,7 +11,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index eab31cb..cd3021b 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 
 #include <media/omap1_camera.h>
 #include <media/soc_camera.h>
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index f6626e8..d3667d2 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -31,7 +31,6 @@
 #include <linux/interrupt.h>
 #include <linux/videodev2.h>
 #include <linux/pci.h>		/* needed for videobufs */
-#include <linux/version.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index 524a1ac..fb83e1a 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -27,7 +27,6 @@
 #define OMAP3_ISP_VIDEO_H
 
 #include <linux/v4l2-mediabus.h>
-#include <linux/version.h>
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 7551907..e83831e 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -28,7 +28,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 3876114..8f8b57d 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include "pvrusb2-context.h"
 #include "pvrusb2-hdw.h"
 #include "pvrusb2.h"
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
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index e947766..d153af1 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -29,7 +29,6 @@
 #include <linux/usb.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 0268677..2bdfbeb 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 561909b..3cf7019 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -47,7 +47,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 95f8b4e1..43d9427 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6c919b3..ce2a871 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index f96cd5d..a7153c7 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -19,7 +19,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/version.h>
 #define SAA7134_VERSION_CODE KERNEL_VERSION(0, 2, 16)
 
 #include <linux/pci.h>
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
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3fe54bf..ec70a10 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -26,7 +26,6 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 07cf0c6..13d6e25 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -19,7 +19,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 
 #include <media/sh_vou.h>
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
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index 84d4c7c..b98c4e4 100644
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
diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/video/tlg2300/pd-radio.c
index fae84c2..8073b5d 100644
--- a/drivers/media/video/tlg2300/pd-radio.c
+++ b/drivers/media/video/tlg2300/pd-radio.c
@@ -6,7 +6,6 @@
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include <media/v4l2-dev.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 6083137..d9e399b 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -45,7 +45,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/timer.h>
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 9005a8d..5f8cec8 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index d63e9d9..5889522 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/kmod.h>
 
 #include <linux/i2c.h>
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..32c7964 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -22,7 +22,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/font.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/kthread.h>
diff --git a/drivers/media/video/w9966.c b/drivers/media/video/w9966.c
index fa35639..c8e0a2b 100644
--- a/drivers/media/video/w9966.c
+++ b/drivers/media/video/w9966.c
@@ -57,7 +57,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 7c3921d..31ab6b5 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -44,7 +44,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 7dfb01e..4a65a6c 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -29,7 +29,6 @@
 
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
-- 
1.7.4.1

