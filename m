Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2FGSrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:47:23 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:40500 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2FGSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:47:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, Philippe De Muyter <phdm@macqel.be>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/5] m68k: Move CPU_HAS_* config options
Date: Thu,  7 Jun 2012 20:47:04 +0200
Message-Id: <1339094827-12349-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
References: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They belong together with the CPU selection

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig     |    9 ---------
 arch/m68k/Kconfig.cpu |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index bc8cc50..87b504c 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -53,15 +53,6 @@ config ZONE_DMA
 	bool
 	default y
 
-config CPU_HAS_NO_BITFIELDS
-	bool
-
-config CPU_HAS_NO_MULDIV64
-	bool
-
-config CPU_HAS_ADDRESS_SPACES
-	bool
-
 config HZ
 	int
 	default 1000 if CLEOPATRA
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 2b53254..6cd8c1a 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -360,6 +360,15 @@ config NODES_SHIFT
 	default "3"
 	depends on !SINGLE_MEMORY_CHUNK
 
+config CPU_HAS_NO_BITFIELDS
+	bool
+
+config CPU_HAS_NO_MULDIV64
+	bool
+
+config CPU_HAS_ADDRESS_SPACES
+	bool
+
 config FPU
 	bool
 
-- 
1.7.0.4

