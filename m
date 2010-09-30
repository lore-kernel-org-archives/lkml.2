Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0I3Tji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:39:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37758 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab0I3Tjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CUGpmnnOGU8eirMauG/ANiAbHjciSLaqvT9VP0ffHIS2fx2anzYa221S9a3+csn2Vn
         OklttLkZltvWUu3gWrBhOENEGFVLPfrz+f3rAZ+/GeVd0Nd/p8NzfQaV30lA6zXCsSqH
         3cBfXoIqpQz64T10mfhJWkuFuyZ6Piue77AR4=
Message-ID: <4CA4E76E.1050602@gmail.com>
Date: Thu, 30 Sep 2010 21:39:26 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org> <AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com> <4CA4D61C.2010909@gmail.com>
In-Reply-To: <4CA4D61C.2010909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  W dniu 2010-09-30 20:25, N.P.S. pisze:
>  W dniu 2010-09-30 18:59, Na Pohybel pisze:
>> Hi,
>>
>> 2010/9/29<akpm@linux-foundation.org>:
>>> The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
>> Could you add this tree to the next mmotm?
>> git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git 
>> rodi
>
> I noticed that some of these changes are already in mmotm.

Here is a patch that removes duplicate includes introduced in -next and 
-mmotm

--
Zimny Lech

  arch/arm/mach-omap2/board-rx51-peripherals.c           |    1 -
  arch/arm/mm/flush.c                                    |    1 -
  arch/xtensa/include/asm/coprocessor.h                  |    1 -
  drivers/mmc/host/ushc.c                                |    1 -
  drivers/staging/ath6kl/os/linux/include/ar6000_drv.h   |    1 -
  drivers/staging/batman-adv/soft-interface.c            |    1 -
  drivers/staging/bcm/headers.h                          |    1 -
  drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c       |    4 ----
  drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h       |    1 -
  drivers/staging/brcm80211/brcmfmac/wl_iw.c             |    4 ----
  drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c     |    1 -
  drivers/staging/rtl8712/drv_types.h                    |    1 -
  drivers/staging/rtl8712/osdep_service.h                |    1 -
  drivers/staging/westbridge/astoria/gadget/cyasgadget.h |    3 ---
  sound/soc/fsl/mpc5200_dma.c                            |    1 -
  15 files changed, 23 deletions(-)


Removal of duplicate includes from 
arch/arm/mach-omap2/board-rx51-peripherals.c
Removal of duplicate includes from arch/arm/mm/flush.c
Removal of duplicate includes from arch/xtensa/include/asm/coprocessor.h
Removal of duplicate includes from drivers/mmc/host/ushc.c
Removal of duplicate includes from 
drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
Removal of duplicate includes from 
drivers/staging/batman-adv/soft-interface.c
Removal of duplicate includes from drivers/staging/bcm/headers.h
Removal of duplicate includes from 
drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
Removal of duplicate includes from 
drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
Removal of duplicate includes from 
drivers/staging/brcm80211/brcmfmac/wl_iw.c
Removal of duplicate includes from 
drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
Removal of duplicate includes from drivers/staging/rtl8712/drv_types.h
Removal of duplicate includes from drivers/staging/rtl8712/osdep_service.h
Removal of duplicate includes from 
drivers/staging/westbridge/astoria/gadget/cyasgadget.h
Removal of duplicate includes from sound/soc/fsl/mpc5200_dma.c

Signed-off-by: N.P.S. <napohybelskurwysynom2010@gmail.com>

diff -uprN 
linux-2.6-mm-orig/arch/arm/mach-omap2/board-rx51-peripherals.c 
linux-2.6-mm/arch/arm/mach-omap2/board-rx51-peripherals.c
--- linux-2.6-mm-orig/arch/arm/mach-omap2/board-rx51-peripherals.c    
2010-09-29 02:04:13.000000000 +0200
+++ linux-2.6-mm/arch/arm/mach-omap2/board-rx51-peripherals.c    
2010-09-30 21:23:49.000000000 +0200
@@ -33,7 +33,6 @@
  #include <plat/onenand.h>
  #include <plat/gpmc-smc91x.h>

-#include <sound/tlv320aic3x.h>
  #include <sound/tpa6130a2-plat.h>

  #include <../drivers/staging/iio/light/tsl2563.h>
diff -uprN linux-2.6-mm-orig/arch/arm/mm/flush.c 
linux-2.6-mm/arch/arm/mm/flush.c
--- linux-2.6-mm-orig/arch/arm/mm/flush.c    2010-09-29 
02:04:13.000000000 +0200
+++ linux-2.6-mm/arch/arm/mm/flush.c    2010-09-30 21:23:22.000000000 +0200
@@ -17,7 +17,6 @@
  #include <asm/smp_plat.h>
  #include <asm/system.h>
  #include <asm/tlbflush.h>
-#include <asm/smp_plat.h>

  #include "mm.h"

diff -uprN linux-2.6-mm-orig/arch/xtensa/include/asm/coprocessor.h 
linux-2.6-mm/arch/xtensa/include/asm/coprocessor.h
--- linux-2.6-mm-orig/arch/xtensa/include/asm/coprocessor.h    
2010-09-29 02:04:15.000000000 +0200
+++ linux-2.6-mm/arch/xtensa/include/asm/coprocessor.h    2010-09-30 
21:23:02.000000000 +0200
@@ -15,7 +15,6 @@
  #include <linux/stringify.h>
  #include <variant/core.h>
  #include <variant/tie.h>
-#include <variant/core.h>
  #include <asm/types.h>

  #if defined(__ASSEMBLY__) && !defined(LINKER_SCRIPT)
diff -uprN linux-2.6-mm-orig/drivers/mmc/host/ushc.c 
linux-2.6-mm/drivers/mmc/host/ushc.c
--- linux-2.6-mm-orig/drivers/mmc/host/ushc.c    2010-09-29 
02:04:17.000000000 +0200
+++ linux-2.6-mm/drivers/mmc/host/ushc.c    2010-09-30 
21:22:48.000000000 +0200
@@ -19,7 +19,6 @@
  #include <linux/module.h>
  #include <linux/usb.h>
  #include <linux/kernel.h>
-#include <linux/usb.h>
  #include <linux/slab.h>
  #include <linux/dma-mapping.h>
  #include <linux/mmc/host.h>
diff -uprN 
linux-2.6-mm-orig/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h 
linux-2.6-mm/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
--- 
linux-2.6-mm-orig/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h    2010-09-29 
02:04:23.000000000 +0200
+++ linux-2.6-mm/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h    
2010-09-30 21:16:50.000000000 +0200
@@ -57,7 +57,6 @@
  #include "aggr_recv_api.h"
  #include <host_version.h>
  #include <linux/rtnetlink.h>
-#include <linux/init.h>
  #include <linux/moduleparam.h>
  #include "ar6000_api.h"
  #ifdef CONFIG_HOST_TCMD_SUPPORT
diff -uprN linux-2.6-mm-orig/drivers/staging/batman-adv/soft-interface.c 
linux-2.6-mm/drivers/staging/batman-adv/soft-interface.c
--- linux-2.6-mm-orig/drivers/staging/batman-adv/soft-interface.c    
2010-09-29 02:04:23.000000000 +0200
+++ linux-2.6-mm/drivers/staging/batman-adv/soft-interface.c    
2010-09-30 21:21:41.000000000 +0200
@@ -28,7 +28,6 @@
  #include "translation-table.h"
  #include "types.h"
  #include "hash.h"
-#include "send.h"
  #include "bat_sysfs.h"
  #include <linux/slab.h>
  #include <linux/ethtool.h>
diff -uprN linux-2.6-mm-orig/drivers/staging/bcm/headers.h 
linux-2.6-mm/drivers/staging/bcm/headers.h
--- linux-2.6-mm-orig/drivers/staging/bcm/headers.h    2010-09-29 
02:04:23.000000000 +0200
+++ linux-2.6-mm/drivers/staging/bcm/headers.h    2010-09-30 
21:16:16.000000000 +0200
@@ -28,7 +28,6 @@

  #include <linux/version.h>
  #include <linux/stddef.h>
-#include <linux/kernel.h>
  #include <linux/stat.h>
  #include <linux/fcntl.h>
  #include <linux/unistd.h>
diff -uprN 
linux-2.6-mm-orig/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c 
linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
--- 
linux-2.6-mm-orig/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c    
2010-09-29 02:04:23.000000000 +0200
+++ linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c    
2010-09-30 21:15:48.000000000 +0200
@@ -30,10 +30,6 @@
  #include <dhdioctl.h>
  #include <wlioctl.h>

-#include <proto/ethernet.h>
-#include <dngl_stats.h>
-#include <dhd.h>
-
  #include <linux/kernel.h>
  #include <linux/netdevice.h>
  #include <linux/sched.h>
diff -uprN 
linux-2.6-mm-orig/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h 
linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
--- 
linux-2.6-mm-orig/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h    
2010-09-29 02:04:23.000000000 +0200
+++ linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h    
2010-09-30 21:15:13.000000000 +0200
@@ -21,7 +21,6 @@
  #include <typedefs.h>
  #include <proto/ethernet.h>
  #include <wlioctl.h>
-#include <linux/wireless.h>
  #include <net/cfg80211.h>

  struct wl_conf;
diff -uprN linux-2.6-mm-orig/drivers/staging/brcm80211/brcmfmac/wl_iw.c 
linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c
--- linux-2.6-mm-orig/drivers/staging/brcm80211/brcmfmac/wl_iw.c    
2010-09-29 02:04:23.000000000 +0200
+++ linux-2.6-mm/drivers/staging/brcm80211/brcmfmac/wl_iw.c    
2010-09-30 21:13:15.000000000 +0200
@@ -34,11 +34,7 @@
  typedef void wlc_info_t;
  typedef void wl_info_t;
  typedef const struct si_pub si_t;
-#include <wlioctl.h>

-#include <proto/ethernet.h>
-#include <dngl_stats.h>
-#include <dhd.h>
  #define WL_ERROR(x) printf x
  #define WL_TRACE(x)
  #define WL_ASSOC(x)
diff -uprN 
linux-2.6-mm-orig/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c 
linux-2.6-mm/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
--- 
linux-2.6-mm-orig/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c    
2010-09-29 02:04:24.000000000 +0200
+++ linux-2.6-mm/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c    
2010-09-30 21:11:46.000000000 +0200
@@ -30,7 +30,6 @@
  #include <linux/netdevice.h>
  #include <linux/timer.h>
  #include <linux/delay.h>
-#include <linux/slab.h>
  #include <asm/io.h>
  #include <asm/uaccess.h>
  #include <linux/vmalloc.h>
diff -uprN linux-2.6-mm-orig/drivers/staging/rtl8712/drv_types.h 
linux-2.6-mm/drivers/staging/rtl8712/drv_types.h
--- linux-2.6-mm-orig/drivers/staging/rtl8712/drv_types.h    2010-09-29 
02:04:25.000000000 +0200
+++ linux-2.6-mm/drivers/staging/rtl8712/drv_types.h    2010-09-30 
21:11:24.000000000 +0200
@@ -29,7 +29,6 @@ struct    qos_priv    {

  #include "rtl871x_ht.h"
  #include "rtl871x_cmd.h"
-#include "wlan_bssdef.h"
  #include "rtl871x_xmit.h"
  #include "rtl871x_recv.h"
  #include "rtl871x_security.h"
diff -uprN linux-2.6-mm-orig/drivers/staging/rtl8712/osdep_service.h 
linux-2.6-mm/drivers/staging/rtl8712/osdep_service.h
--- linux-2.6-mm-orig/drivers/staging/rtl8712/osdep_service.h    
2010-09-29 02:04:25.000000000 +0200
+++ linux-2.6-mm/drivers/staging/rtl8712/osdep_service.h    2010-09-30 
21:10:52.000000000 +0200
@@ -23,7 +23,6 @@
  #include <linux/sched.h>
  #include <linux/kref.h>
  #include <linux/smp_lock.h>
-#include <linux/netdevice.h>
  #include <linux/skbuff.h>
  #include <linux/usb.h>
  #include <linux/usb/ch9.h>
diff -uprN 
linux-2.6-mm-orig/drivers/staging/westbridge/astoria/gadget/cyasgadget.h 
linux-2.6-mm/drivers/staging/westbridge/astoria/gadget/cyasgadget.h
--- 
linux-2.6-mm-orig/drivers/staging/westbridge/astoria/gadget/cyasgadget.h    
2010-09-29 02:04:25.000000000 +0200
+++ 
linux-2.6-mm/drivers/staging/westbridge/astoria/gadget/cyasgadget.h    
2010-09-30 21:10:25.000000000 +0200
@@ -64,9 +64,6 @@
  #include <linux/init.h>

  /*char driver defines, revisit*/
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/init.h>
  #include <linux/fs.h>        /* everything... */
  #include <linux/errno.h>    /* error codes */
  #include <linux/types.h>    /* size_t */
diff -uprN linux-2.6-mm-orig/sound/soc/fsl/mpc5200_dma.c 
linux-2.6-mm/sound/soc/fsl/mpc5200_dma.c
--- linux-2.6-mm-orig/sound/soc/fsl/mpc5200_dma.c    2010-09-30 
21:05:37.000000000 +0200
+++ linux-2.6-mm/sound/soc/fsl/mpc5200_dma.c    2010-09-30 
21:09:51.000000000 +0200
@@ -9,7 +9,6 @@
  #include <linux/module.h>
  #include <linux/of_device.h>
  #include <linux/slab.h>
-#include <linux/of_device.h>
  #include <linux/of_platform.h>

  #include <sound/soc.h>


