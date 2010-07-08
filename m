Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0GHNzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:55:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39674 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab0GHNzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:55:38 -0400
From: pavan_savoy@ti.com
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 1/2] drivers:staging:ti-st: Update TODO
Date: Thu,  8 Jul 2010 08:55:16 -0500
Message-Id: <1278597317-31389-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1278597317-31389-1-git-send-email-pavan_savoy@ti.com>
References: <1278597317-31389-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

An important TODO was to remove global references in TI-ST driver,
thereby providing a context to the driver.
This should also serve as a small step in removal of the single device
limit.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/TODO |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
index 26f3ae3..3f68ea1 100644
--- a/drivers/staging/ti-st/TODO
+++ b/drivers/staging/ti-st/TODO
@@ -18,7 +18,9 @@ http://git.omapzoom.org/?p
 4. Re-structure to make the ldisc driver more generic for chipsets which mux
 multiple connectivity (BT, FM, GPS) upon 1 TTY port.
 
-5. Step up and maintain this driver to ensure that it continues
+5. Remove global references by providing a context which can be moved around the driver like the other ldisc drivers. (ldiscs tend to use tty's disc_data and platform devices use the device's driver data)
+
+6. Step up and maintain this driver to ensure that it continues
 to work.  Having the hardware for this is pretty much a
 requirement.  If this does not happen, the will be removed in
 the 2.6.35 kernel release.
-- 
1.5.6.3

