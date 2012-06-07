Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab2FGSsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:48:04 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:33127 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab2FGSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:47:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, Philippe De Muyter <phdm@macqel.be>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/5] m68k: Remove duplicate FPU config option
Date: Thu,  7 Jun 2012 20:47:03 +0200
Message-Id: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's also defined in arch/m68k/Kconfig.cpu

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 1471201..bc8cc50 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -62,9 +62,6 @@ config CPU_HAS_NO_MULDIV64
 config CPU_HAS_ADDRESS_SPACES
 	bool
 
-config FPU
-	bool
-
 config HZ
 	int
 	default 1000 if CLEOPATRA
-- 
1.7.0.4

