Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214Ab1IKMAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:00:55 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38304 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Hirst <rhirst@parisc-linux.org>
Subject: [PATCH 22/28] m68k/vme: Convert VME to genirq
Date: Sun, 11 Sep 2011 13:59:48 +0200
Message-Id: <1315742394-16036-23-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Hirst <rhirst@parisc-linux.org>
---
v3: Added this changeset
---
 arch/m68k/Kconfig.mmu |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index 9707db5..258d92b 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -201,9 +201,6 @@ config SUN3
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
 	depends on !APOLLO
-	depends on !MVME147
-	depends on !MVME16x
-	depends on !BVME6000
 	depends on !SUN3X
 	depends on !Q40
 	depends on !SUN3
-- 
1.7.0.4

