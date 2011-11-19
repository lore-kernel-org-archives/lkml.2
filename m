Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1KSPD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:03:27 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:51265 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1KSPDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:03:23 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 01/16] mtd/docg3: fix debug log verbosity
Date: Sat, 19 Nov 2011 16:02:43 +0100
Message-Id: <1321714978-24543-2-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the NOP debug log verbosity to very verbose to
unburden log analysis.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index bdcf5df..6f5233d 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -143,7 +143,7 @@ static void doc_delay(struct docg3 *docg3, int nbNOPs)
 {
 	int i;
 
-	doc_dbg("NOP x %d\n", nbNOPs);
+	doc_vdbg("NOP x %d\n", nbNOPs);
 	for (i = 0; i < nbNOPs; i++)
 		doc_writeb(docg3, 0, DOC_NOP);
 }
-- 
1.7.5.4

