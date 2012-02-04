Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2BDMrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:47:17 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:54279
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753321Ab2BDMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:47:16 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: liqin.chen@sunplusct.com, lennox.wu@gmail.com
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] score: Fix typo in Kconfig.debug
Date: Sat,  4 Feb 2012 21:46:25 +0900
Message-Id: <1328359585-1808-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "debuging" to "debugging" in
arch/score/Kconfig.debug

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/score/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/score/Kconfig.debug b/arch/score/Kconfig.debug
index a1f346d..d8a9b2d 100644
--- a/arch/score/Kconfig.debug
+++ b/arch/score/Kconfig.debug
@@ -22,7 +22,7 @@ config RUNTIME_DEBUG
 	help
 	  If you say Y here, some debugging macros will do run-time checking.
 	  If you say N here, those macros will mostly turn to no-ops.  See
-	  include/asm-score/debug.h for debuging macros.
+	  include/asm-score/debug.h for debugging macros.
 	  If unsure, say N.
 
 endmenu
-- 
1.7.6.5

