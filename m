Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab0KLVjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:39:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804Ab0KLViP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:15 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, David Woodhouse <dwmw2@infradead.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] drivers/mtd/nand: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:58 -0800
Message-Id: <7b7e68efb016f0b0d53bb3119208dd937c79d53c.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mtd/nand/pasemi_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 6ddb246..bb277a5 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -107,7 +107,7 @@ static int __devinit pasemi_nand_probe(struct platform_device *ofdev,
 	if (pasemi_nand_mtd)
 		return -ENODEV;
 
-	pr_debug("pasemi_nand at %llx-%llx\n", res.start, res.end);
+	pr_debug("pasemi_nand at %pR\n", &res);
 
 	/* Allocate memory for MTD device structure and private data */
 	pasemi_nand_mtd = kzalloc(sizeof(struct mtd_info) +
-- 
1.7.3.1.g432b3.dirty

