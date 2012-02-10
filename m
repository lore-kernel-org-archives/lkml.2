Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2BJPmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:42:43 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:42911
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753005Ab2BJPmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:42:42 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: wim@iguana.be, linux-watchdog@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] watchdog: Fix typo in Kconfig
Date: Sat, 11 Feb 2012 00:42:16 +0900
Message-Id: <1328888536-3872-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "overidden" to "overridden" in
drivers/watchdog/Kconfig

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/watchdog/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 877b107..df9e8f0 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1098,7 +1098,7 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
 	  For Freescale Book-E processors, this is a number between 0 and 63.
 	  For other Book-E processors, this is a number between 0 and 3.
 
-	  The value can be overidden by the wdt_period command-line parameter.
+	  The value can be overridden by the wdt_period command-line parameter.
 
 # PPC64 Architecture
 
-- 
1.7.6.5

