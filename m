Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2BHMIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:08:50 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:50352
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756351Ab2BHMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:08:49 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: peppe.cavallaro@st.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] stmmac: Fix typo in stmmac_pci.c
Date: Wed,  8 Feb 2012 21:08:21 +0900
Message-Id: <1328702901-2157-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "regiser" to "register" in
drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index c796de9..6ce0706 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -85,7 +85,7 @@ static int __devinit stmmac_pci_probe(struct pci_dev *pdev,
 			continue;
 		addr = pci_iomap(pdev, i, 0);
 		if (addr == NULL) {
-			pr_err("%s: ERROR: cannot map regiser memory, aborting",
+			pr_err("%s: ERROR: cannot map register memory, aborting",
 			       __func__);
 			ret = -EIO;
 			goto err_out_map_failed;
-- 
1.7.6.5

