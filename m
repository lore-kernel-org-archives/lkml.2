Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab0KOUOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:14:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1340 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933633Ab0KOUOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:08 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] drivers/ide/pmac.c: Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:13:53 -0800
Message-Id: <9a1859d08801fcd813f75b1a79dfcd68ba51b58f.1289851770.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/pmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index ebcf8e4..1db7c43 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1334,7 +1334,7 @@ out_free_pmif:
 static int
 pmac_ide_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	pmac_ide_hwif_t *pmif = pci_get_drvdata(pdev);
 	int rc = 0;
 
 	if (mesg.event != pdev->dev.power.power_state.event
@@ -1350,7 +1350,7 @@ pmac_ide_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 static int
 pmac_ide_pci_resume(struct pci_dev *pdev)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	pmac_ide_hwif_t *pmif = pci_get_drvdata(pdev);
 	int rc = 0;
 
 	if (pdev->dev.power.power_state.event != PM_EVENT_ON) {
-- 
1.7.3.1.g432b3.dirty

