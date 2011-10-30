Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab1J3Mx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:53:26 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:36229 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab1J3Mss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Philip Blundell <philb@gnu.org>
Subject: [PATCH 19/27] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
Date: Sun, 30 Oct 2011 13:48:27 +0100
Message-Id: <1319978915-10933-20-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philip Blundell <philb@gnu.org>
---
 arch/m68k/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 9ba1a89..e4bd0c9 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -91,7 +91,6 @@ config USE_GENERIC_HARDIRQS
 	depends on !MVME147
 	depends on !MVME16x
 	depends on !BVME6000
-	depends on !HP300
 	depends on !SUN3X
 	depends on !Q40
 	depends on !SUN3
-- 
1.7.0.4

