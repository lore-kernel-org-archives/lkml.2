Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab1IKMCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:02:50 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42712 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760116Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Philip Blundell <philb@gnu.org>
Subject: [PATCH 21/28] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
Date: Sun, 11 Sep 2011 13:59:47 +0200
Message-Id: <1315742394-16036-22-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philip Blundell <philb@gnu.org>
---
v3: Added this changeset
---
 arch/m68k/Kconfig.mmu |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index 24f39df..9707db5 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -204,7 +204,6 @@ config USE_GENERIC_HARDIRQS
 	depends on !MVME147
 	depends on !MVME16x
 	depends on !BVME6000
-	depends on !HP300
 	depends on !SUN3X
 	depends on !Q40
 	depends on !SUN3
-- 
1.7.0.4

