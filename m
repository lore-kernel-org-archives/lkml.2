Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2BDMk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:40:56 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:54274
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752828Ab2BDMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:40:54 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: lethal@linux-sh.org, magnus.damm@gmail.com, linux-sh@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] sh: Fix typo in pci-sh7780.c
Date: Sat,  4 Feb 2012 21:40:24 +0900
Message-Id: <1328359224-1724-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "erorr" to "error" in
arch/sh/drivers/pci/pci-sh7780.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/sh/drivers/pci/pci-sh7780.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/drivers/pci/pci-sh7780.c b/arch/sh/drivers/pci/pci-sh7780.c
index fa7b978..fb8f1499 100644
--- a/arch/sh/drivers/pci/pci-sh7780.c
+++ b/arch/sh/drivers/pci/pci-sh7780.c
@@ -74,7 +74,7 @@ struct pci_errors {
 	{ SH4_PCIINT_MLCK,	"master lock error" },
 	{ SH4_PCIINT_TABT,	"target-target abort" },
 	{ SH4_PCIINT_TRET,	"target retry time out" },
-	{ SH4_PCIINT_MFDE,	"master function disable erorr" },
+	{ SH4_PCIINT_MFDE,	"master function disable error" },
 	{ SH4_PCIINT_PRTY,	"address parity error" },
 	{ SH4_PCIINT_SERR,	"SERR" },
 	{ SH4_PCIINT_TWDP,	"data parity error for target write" },
-- 
1.7.6.5

