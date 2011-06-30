Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1F3Vs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:48:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50316 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1F3Vsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:48:42 -0400
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: [PATCH 2/2] Making sure GEODE_WDT depends on CONFIG_MFD_CS5535
Date: Thu, 30 Jun 2011 21:48:03 +0000
Message-Id: <1309470483-18546-3-git-send-email-gurligebis@gentoo.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309470483-18546-1-git-send-email-gurligebis@gentoo.org>
References: <1309470483-18546-1-git-send-email-gurligebis@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>

Fixes dependency problem for GEODE_WDT.

Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
---
 drivers/watchdog/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9536d38..b9f2c66 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -432,7 +432,7 @@ config SP5100_TCO
 
 config GEODE_WDT
 	tristate "AMD Geode CS5535/CS5536 Watchdog"
-	depends on CS5535_MFGPT
+	depends on CS5535_MFGPT && CONFIG_MFD_CS5535
 	help
 	  This driver enables a watchdog capability built into the
 	  CS5535/CS5536 companion chips for the AMD Geode GX and LX
-- 
1.7.6

