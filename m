Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab0KOUQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:16:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1345 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933659Ab0KOUOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:09 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] drivers/misc/ibmasm/module.c: Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:13:55 -0800
Message-Id: <a9a0226e67cea178722458e46e36cddc961d5832.1289851770.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/misc/ibmasm/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
index a234d96..9e5e407 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -165,7 +165,7 @@ error_resources:
 
 static void __devexit ibmasm_remove_one(struct pci_dev *pdev)
 {
-	struct service_processor *sp = (struct service_processor *)pci_get_drvdata(pdev);
+	struct service_processor *sp = pci_get_drvdata(pdev);
 
 	dbg("Unregistering UART\n");
 	ibmasm_unregister_uart(sp);
-- 
1.7.3.1.g432b3.dirty

