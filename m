Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1C1Qaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48024 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1C1Qae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Dx9OTuph0RVLwdaQh2qa+TDl1RFU1nvmlgrqKFpcU/Hmq/he2i1Q4ZpNOrAuI4GEJg
         lCK3oEIJspu2CSUeaGXmobbaV7tILMX/4IVxQ5k2oIb9gr9jiBaz2F7+ljfCy/3P9Tnq
         V0LDNIZuNsVGGydHcQ6f2coXRcxsRjuJguykI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 16/25]drivers:staging Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:39 -0700
Message-Id: <1301329788-3423-17-git-send-email-justinmattock@gmail.com>
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
 .../staging/ath6kl/os/linux/include/config_linux.h |    2 --
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |    2 --
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    1 -
 drivers/staging/bcm/headers.h                      |    1 -
 drivers/staging/cx25821/cx25821.h                  |    1 -
 drivers/staging/cxd2099/cxd2099.c                  |    1 -
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |    1 -
 drivers/staging/dt3155v4l/dt3155v4l.c              |    1 -
 drivers/staging/easycap/easycap.h                  |    1 -
 drivers/staging/gma500/psb_bl.c                    |    1 -
 drivers/staging/gma500/psb_drv.h                   |    2 --
 drivers/staging/gma500/psb_fb.h                    |    1 -
 drivers/staging/go7007/go7007-v4l2.c               |    1 -
 drivers/staging/hv/hv_timesource.c                 |    1 -
 drivers/staging/lirc/lirc_ttusbir.c                |    1 -
 drivers/staging/lirc/lirc_zilog.c                  |    1 -
 drivers/staging/msm/ebi2_lcd.c                     |    3 +--
 drivers/staging/msm/msm_fb.c                       |    1 -
 drivers/staging/msm/msm_fb_bl.c                    |    1 -
 drivers/staging/msm/msm_fb_def.h                   |    1 -
 drivers/staging/msm/msm_fb_panel.c                 |    1 -
 drivers/staging/panel/panel.c                      |    1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    1 -
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    1 -
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    1 -
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |    1 -
 drivers/staging/rtl8192e/r8192E.h                  |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.c   |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    1 -
 drivers/staging/rtl8192u/r8192U.h                  |    1 -
 drivers/staging/rtl8712/osdep_service.h            |    1 -
 drivers/staging/rts_pstor/rtsx.h                   |    1 -
 drivers/staging/solo6x10/solo6x10.h                |    1 -
 drivers/staging/speakup/main.c                     |    1 -
 drivers/staging/speakup/speakup.h                  |    1 -
 .../tidspbridge/include/dspbridge/host_os.h        |    1 -
 drivers/staging/tm6000/tm6000-cards.c              |    1 -
 drivers/staging/tm6000/tm6000-video.c              |    1 -
 drivers/staging/usbip/usbip_common.h               |    1 -
 drivers/staging/wlags49_h2/wl_internal.h           |    1 -
 drivers/staging/wlags49_h2/wl_version.h            |    1 -
 drivers/staging/wlan-ng/prism2sta.c                |    1 -
 drivers/staging/xgifb/XGI_main_26.c                |    1 -
 drivers/staging/xgifb/vb_ext.c                     |    1 -
 drivers/staging/xgifb/vb_init.c                    |    1 -
 drivers/staging/xgifb/vb_setmode.c                 |    1 -
 65 files changed, 1 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/include/config_linux.h b/drivers/staging/ath6kl/os/linux/include/config_linux.h
index 50f53d3..6d13d51 100644
--- a/drivers/staging/ath6kl/os/linux/include/config_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/config_linux.h
@@ -28,8 +28,6 @@
 extern "C" {
 #endif
 
-#include <linux/version.h>
-
 /*
  * Host-side GPIO support is optional.
  * If run-time access to GPIO pins is not required, then
diff --git a/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h b/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
index 769a480..e6e96de 100644
--- a/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
+++ b/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
@@ -24,8 +24,6 @@
 #ifndef _IEEE80211_IOCTL_H_
 #define _IEEE80211_IOCTL_H_
 
-#include <linux/version.h>
-
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index 53b500c..0ad9b72 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -29,7 +29,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/drivers/staging/bcm/headers.h b/drivers/staging/bcm/headers.h
index 1148e5e..ab0a1db 100644
--- a/drivers/staging/bcm/headers.h
+++ b/drivers/staging/bcm/headers.h
@@ -25,7 +25,6 @@
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 
-#include <linux/version.h>
 #include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/stat.h>
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index 6230243..d532e04 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -46,7 +46,6 @@
 #include "cx25821-audio.h"
 #include "media/cx2341x.h"
 
-#include <linux/version.h>
 #include <linux/mutex.h>
 
 #define CX25821_VERSION_CODE KERNEL_VERSION(0, 0, 106)
diff --git a/drivers/staging/cxd2099/cxd2099.c b/drivers/staging/cxd2099/cxd2099.c
index b49186c..55b1c4a 100644
--- a/drivers/staging/cxd2099/cxd2099.c
+++ b/drivers/staging/cxd2099/cxd2099.c
@@ -22,7 +22,6 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index 501a331..c0563e6 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -47,7 +47,6 @@
 #include <sys/types.h>
 #else
 #include <linux/types.h>
-#include <linux/version.h>
 #if defined(CONFIG_SMP) && ! defined(__SMP__)
 #define __SMP__
 #endif
diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index 15d7efe..d83ff18 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -18,7 +18,6 @@
  *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 
-#include <linux/version.h>
 #include <linux/stringify.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
diff --git a/drivers/staging/easycap/easycap.h b/drivers/staging/easycap/easycap.h
index 1f94e23..efbd61b 100644
--- a/drivers/staging/easycap/easycap.h
+++ b/drivers/staging/easycap/easycap.h
@@ -62,7 +62,6 @@
 #include <linux/uaccess.h>
 
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 70c17b3..2636545 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/backlight.h>
-#include <linux/version.h>
 #include "psb_drv.h"
 #include "psb_intel_reg.h"
 #include "psb_intel_drv.h"
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 29a3605..bd1f56d 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -20,8 +20,6 @@
 #ifndef _PSB_DRV_H_
 #define _PSB_DRV_H_
 
-#include <linux/version.h>
-
 #include <drm/drmP.h>
 #include "drm_global.h"
 #include "psb_drm.h"
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
index b4fab92..919c640 100644
--- a/drivers/staging/gma500/psb_fb.h
+++ b/drivers/staging/gma500/psb_fb.h
@@ -22,7 +22,6 @@
 #ifndef _PSB_FB_H_
 #define _PSB_FB_H_
 
-#include <linux/version.h>
 #include <drm/drmP.h>
 #include <drm/drm_fb_helper.h>
 
diff --git a/drivers/staging/go7007/go7007-v4l2.c b/drivers/staging/go7007/go7007-v4l2.c
index 2b27d8d..006fb86 100644
--- a/drivers/staging/go7007/go7007-v4l2.c
+++ b/drivers/staging/go7007/go7007-v4l2.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
diff --git a/drivers/staging/hv/hv_timesource.c b/drivers/staging/hv/hv_timesource.c
index a7ee533..0b79071 100644
--- a/drivers/staging/hv/hv_timesource.c
+++ b/drivers/staging/hv/hv_timesource.c
@@ -21,7 +21,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/drivers/staging/lirc/lirc_ttusbir.c b/drivers/staging/lirc/lirc_ttusbir.c
index e345ab9..e4b329b 100644
--- a/drivers/staging/lirc/lirc_ttusbir.c
+++ b/drivers/staging/lirc/lirc_ttusbir.c
@@ -30,7 +30,6 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index dd6a57c..8e64b86 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -40,7 +40,6 @@
  */
 
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/msm/ebi2_lcd.c b/drivers/staging/msm/ebi2_lcd.c
index b41e123..4834b7b 100644
--- a/drivers/staging/msm/ebi2_lcd.c
+++ b/drivers/staging/msm/ebi2_lcd.c
@@ -29,7 +29,6 @@
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
@@ -247,4 +246,4 @@ static int __init ebi2_lcd_driver_init(void)
 	return ebi2_lcd_register_driver();
 }
 
-module_init(ebi2_lcd_driver_init);
\ No newline at end of file
+module_init(ebi2_lcd_driver_init);
diff --git a/drivers/staging/msm/msm_fb.c b/drivers/staging/msm/msm_fb.c
index a2f29d4..e68adf0 100644
--- a/drivers/staging/msm/msm_fb.c
+++ b/drivers/staging/msm/msm_fb.c
@@ -32,7 +32,6 @@
 
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
diff --git a/drivers/staging/msm/msm_fb_bl.c b/drivers/staging/msm/msm_fb_bl.c
index 2a80775..9c8cb88 100644
--- a/drivers/staging/msm/msm_fb_bl.c
+++ b/drivers/staging/msm/msm_fb_bl.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/backlight.h>
 
 #include "msm_fb.h"
diff --git a/drivers/staging/msm/msm_fb_def.h b/drivers/staging/msm/msm_fb_def.h
index bc7f256..8b4626f 100644
--- a/drivers/staging/msm/msm_fb_def.h
+++ b/drivers/staging/msm/msm_fb_def.h
@@ -28,7 +28,6 @@
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
diff --git a/drivers/staging/msm/msm_fb_panel.c b/drivers/staging/msm/msm_fb_panel.c
index b17a239..651de16 100644
--- a/drivers/staging/msm/msm_fb_panel.c
+++ b/drivers/staging/msm/msm_fb_panel.c
@@ -29,7 +29,6 @@
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 6885f9a..b303b7e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -51,7 +51,6 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/parport.h>
-#include <linux/version.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index dc608c7..5fe7124 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -25,7 +25,6 @@
 #define IEEE80211_H
 #include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/kernel.h>   /* ARRAY_SIZE */
-#include <linux/version.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index c8dbcb9..b3882ae 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -12,7 +12,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 731d268..6aaaa2f 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
index ee71ee9..da24e43 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
index f790cd6..58f3eeb 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
index 9d58a42..9422573 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 771e019..500f6ea 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -19,7 +19,6 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/uaccess.h>
 
 #include "dot11d.h"
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211.h b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
index 3ca3881..ab8d1e2 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
@@ -25,7 +25,6 @@
 #define IEEE80211_H
 #include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/kernel.h>   /* ARRAY_SIZE */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
index ae50379..61fd4ce 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
@@ -12,7 +12,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
index 9b8533f..48267a0 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
index b32b7e6..ed623a9 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
index e626472..5504391 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
@@ -9,7 +9,6 @@
  * more details.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 663b0b8..c1c294e 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -45,7 +45,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
index add015e..d681a7e 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index f6922d4..73a91b5 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -19,7 +19,6 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/uaccess.h>
 #ifdef ENABLE_DOT11D
 #include "dot11d.h"
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
index 995346d..de2ed72 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
index 6530d9b..ae20a23 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -30,7 +30,6 @@
 
 ******************************************************************************/
 #include <linux/wireless.h>
-#include <linux/version.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
 #include <linux/module.h>
diff --git a/drivers/staging/rtl8192e/r8192E.h b/drivers/staging/rtl8192e/r8192E.h
index 0229031..0faa637 100644
--- a/drivers/staging/rtl8192e/r8192E.h
+++ b/drivers/staging/rtl8192e/r8192E.h
@@ -35,7 +35,6 @@
 #include <linux/proc_fs.h>	// Necessary because we use the proc fs
 #include <linux/if_arp.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <asm/io.h>
 #include "ieee80211/rtl819x_HT.h"
 #include "ieee80211/ieee80211.h"
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index c0b844d..1e63b5a 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -25,7 +25,6 @@
 #define IEEE80211_H
 #include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/kernel.h>   /* ARRAY_SIZE */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
index 8707eba..a464d11 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
@@ -12,7 +12,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
index 4b078e5..fec0176 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index a98584c..555eb80 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
index 96c2c9d..3801f12 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index fe978f3..50167b7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 498b520..209a99e 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -37,7 +37,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 4992d63..8ac42ae 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -19,7 +19,6 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/uaccess.h>
 #include "dot11d.h"
 
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index 0205079..9b81f26 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -37,7 +37,6 @@
 #include <linux/proc_fs.h>	// Necessary because we use the proc fs
 #include <linux/if_arp.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <asm/io.h>
 #include "ieee80211/ieee80211.h"
 
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 36eeb5a..5b946d3 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -5,7 +5,6 @@
 #define _FAIL		0
 
 #include "basic_types.h"
-#include <linux/version.h>
 #include <linux/spinlock.h>
 
 #include <linux/semaphore.h>
diff --git a/drivers/staging/rts_pstor/rtsx.h b/drivers/staging/rts_pstor/rtsx.h
index 4d5ddf6..7158e27 100644
--- a/drivers/staging/rts_pstor/rtsx.h
+++ b/drivers/staging/rts_pstor/rtsx.h
@@ -29,7 +29,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
diff --git a/drivers/staging/solo6x10/solo6x10.h b/drivers/staging/solo6x10/solo6x10.h
index fd59b09..f692fc7 100644
--- a/drivers/staging/solo6x10/solo6x10.h
+++ b/drivers/staging/solo6x10/solo6x10.h
@@ -20,7 +20,6 @@
 #ifndef __SOLO6X10_H
 #define __SOLO6X10_H
 
-#include <linux/version.h>
 #include <linux/pci.h>
 #include <linux/i2c.h>
 #include <linux/semaphore.h>
diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 42fcf7e..8be5604 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -23,7 +23,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/vt.h>
 #include <linux/tty.h>
 #include <linux/mm.h>		/* __get_free_page() and friends */
diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/speakup.h
index 46edabe..412b879 100644
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -1,6 +1,5 @@
 #ifndef _SPEAKUP_H
 #define _SPEAKUP_H
-#include <linux/version.h>
 
 #include "spk_types.h"
 #include "i18n.h"
diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index b1b8acb..1a38896 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -24,7 +24,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/syscalls.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/stddef.h>
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 146c7e8..85c8f98 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/usb.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c80a316..a4edec4 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -30,7 +30,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 9f809c3..f205e08 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -21,7 +21,6 @@
 #define __VHCI_COMMON_H
 
 
-#include <linux/version.h>
 #include <linux/usb.h>
 #include <asm/byteorder.h>
 #include <net/sock.h>
diff --git a/drivers/staging/wlags49_h2/wl_internal.h b/drivers/staging/wlags49_h2/wl_internal.h
index cd129b3..a90c728 100644
--- a/drivers/staging/wlags49_h2/wl_internal.h
+++ b/drivers/staging/wlags49_h2/wl_internal.h
@@ -67,7 +67,6 @@
 /*******************************************************************************
  *  include files
  ******************************************************************************/
-#include <linux/version.h>
 #ifdef BUS_PCMCIA
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/staging/wlags49_h2/wl_version.h b/drivers/staging/wlags49_h2/wl_version.h
index a5e604c..a5faada 100644
--- a/drivers/staging/wlags49_h2/wl_version.h
+++ b/drivers/staging/wlags49_h2/wl_version.h
@@ -66,7 +66,6 @@
  *  include files
  ******************************************************************************/
 //#include <linux/config.h>
-#include <linux/version.h>
 
 #ifndef CONFIG_MODVERSIONS
 #define __NO_VERSION__
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index ed751f4..0e7cf0c 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -50,7 +50,6 @@
 * --------------------------------------------------------------------
 */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 721bd25..e653fef 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -5,7 +5,6 @@
  */
 
 /* #include <linux/config.h> */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index d7c1b2e..217329d 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -1,4 +1,3 @@
-#include <linux/version.h>
 #include <asm/io.h>
 #include <linux/types.h>
 #include "XGIfb.h"
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 61d1370..c3f318e 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1,6 +1,5 @@
 #include "vgatypes.h"
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/delay.h> /* udelay */
 #include "XGIfb.h"
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 8762a53..0b768a2 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2,7 +2,6 @@
 #include <asm/io.h>
 #include <linux/delay.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include "XGIfb.h"
 
 
-- 
1.7.4.1

