Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0G1H0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:26:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42809 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab0G1H0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:26:18 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/2] drivers:staging:ti-st: update ABI and TODO
Date: Wed, 28 Jul 2010 02:26:00 -0500
Message-Id: <1280301960-16474-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1280301960-16474-1-git-send-email-pavan_savoy@ti.com>
References: <1280301960-16474-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

update TODO to reflect the items taken care of,
update ABI to reflect the new debugfs entries exposed.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/TODO      |   10 +++-------
 drivers/staging/ti-st/sysfs-uim |   12 ++++++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
index 3f68ea1..6a105ed 100644
--- a/drivers/staging/ti-st/TODO
+++ b/drivers/staging/ti-st/TODO
@@ -11,16 +11,12 @@ a st_register() would know whether the registration from BT/FM or GPS was intend
 2. Improve upon the way requirement of line discipline is communicated to
 user-space, The current user-space application which open/installs ldisc
 as and when required can be found at,
-http://git.omapzoom.org/?pÿatform/hardware/ti/omap3.git;aÿob;fÿ_st/uim/uim.c;ha16c2c2b5085eb54a1bbc7096d779d7594eb11;hbìlair
+http://dev.omapzoom.org/pub/scm/jsistla/L23-btfm.git
+branch: UIM
 
 3. Re-view/Re-work on the locking.
 
-4. Re-structure to make the ldisc driver more generic for chipsets which mux
-multiple connectivity (BT, FM, GPS) upon 1 TTY port.
-
-5. Remove global references by providing a context which can be moved around the driver like the other ldisc drivers. (ldiscs tend to use tty's disc_data and platform devices use the device's driver data)
-
-6. Step up and maintain this driver to ensure that it continues
+4. Step up and maintain this driver to ensure that it continues
 to work.  Having the hardware for this is pretty much a
 requirement.  If this does not happen, the will be removed in
 the 2.6.35 kernel release.
diff --git a/drivers/staging/ti-st/sysfs-uim b/drivers/staging/ti-st/sysfs-uim
index 10311af..626bda5 100644
--- a/drivers/staging/ti-st/sysfs-uim
+++ b/drivers/staging/ti-st/sysfs-uim
@@ -14,3 +14,15 @@ Description:
 		uninstallation would be ppolling on this device and listening
 		on events which would suggest either to install or un-install
 		line discipline
+
+What:           /sys/kernel/debug/ti-st/version
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+		WiLink chip's ROM version exposed to user-space for some
+		proprietary protocol stacks to make use of.
+
+What:           /sys/kernel/debug/ti-st/protocols
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+		The reason for chip being ON, the list of protocols registered.
+
-- 
1.5.6.3

