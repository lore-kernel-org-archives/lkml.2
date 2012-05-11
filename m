Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2EKISd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:18:33 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:53214 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2EKISa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:18:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAKjKrE9bdWOb/2dsb2JhbABEtB6BB4MVgT4TiBK7DJE0BJV9kECCaw
X-IronPort-AV: E=Sophos;i="4.75,570,1330902000"; 
   d="scan'208";a="513690768"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] Staging: move the position of the ipack source line in Kconfig
Date: Fri, 11 May 2012 10:17:10 +0200
Message-Id: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved the ipack source line to the proper place, at the end of the list in the
staging's Kconfig file.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 781cb98..d6417d11 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -24,8 +24,6 @@ menuconfig STAGING
 
 if STAGING
 
-source "drivers/staging/ipack/Kconfig"
-
 source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
@@ -130,4 +128,6 @@ source "drivers/staging/ramster/Kconfig"
 
 source "drivers/staging/ozwpan/Kconfig"
 
+source "drivers/staging/ipack/Kconfig"
+
 endif # STAGING
-- 
1.7.10

