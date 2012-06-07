Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2FGSrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:47:20 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:33128 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab2FGSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:47:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, Philippe De Muyter <phdm@macqel.be>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/5] m68k: CPU32 does not support unaligned accesses
Date: Thu,  7 Jun 2012 20:47:07 +0200
Message-Id: <1339094827-12349-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
References: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hence select CPU_HAS_NO_UNALIGNED

Reported-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig.cpu |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index c4ed650..d4f3a98 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -50,6 +50,7 @@ config M68000
 config MCPU32
 	bool
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_UNALIGNED
 	help
 	  The Freescale (was then Motorola) CPU32 is a CPU core that is
 	  based on the 68020 processor. For the most part it is used in
-- 
1.7.0.4

