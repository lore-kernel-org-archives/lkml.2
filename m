Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1E1HkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 03:40:07 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:47567 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1E1HkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 03:40:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>, Daniel Hellstrom <daniel@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] sparc: Do not select GENERIC_HARDIRQS_NO_DEPRECATED
Date: Sat, 28 May 2011 09:39:56 +0200
Message-Id: <1306568396-10438-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Config option GENERIC_HARDIRQS_NO_DEPRECATED was removed in commit
78c89825649a9a5ed526c507603196f467d781a5 ("genirq: Remove the now obsolete
config options and select statements"), but the select was accidentally
reintroduced in commit 6baa9b20a68a88c2fd751cbe8d7652009379351b
("sparc32: genirq support")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sparc/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index af32e17..789e178 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -26,7 +26,6 @@ config SPARC
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 	select USE_GENERIC_SMP_HELPERS if SMP
 
-- 
1.7.0.4

