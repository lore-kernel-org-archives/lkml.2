Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1EYRFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:05:03 -0400
Received: from mail.perches.com ([173.55.12.10]:2013 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab1EYRCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:02:45 -0400
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Dowan Kim <dowan@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: Remove direct includes of printk.h
Date: Wed, 25 May 2011 10:02:39 -0700
Message-Id: <a605f8a8039f83fae3fbf61b58f846bc3c58c379.1306342673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
References: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
In-Reply-To: <cover.1306342673.git.joe@perches.com>
References: <cover.1306342673.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the uses kernel.h instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    1 -
 drivers/staging/brcm80211/util/bcmutils.c     |    1 -
 drivers/staging/usbip/usbip_common.h          |    2 +-
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index a71c6f8..b00029a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -16,7 +16,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/printk.h>
 #include <linux/pci_ids.h>
 #include <linux/netdevice.h>
 #include <bcmdefs.h>
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 43e5bb3..1c8b6c6 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -21,7 +21,6 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
-#include <linux/printk.h>
 #include <bcmdefs.h>
 #include <stdarg.h>
 #include <bcmutils.h>
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 4a641c5..0f9176d 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -24,7 +24,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/net.h>
-#include <linux/printk.h>
+#include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/usb.h>
-- 
1.7.4.rc3

