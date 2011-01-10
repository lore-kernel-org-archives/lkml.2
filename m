Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1AJWSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:18:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48175 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754524Ab1AJWSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:18:45 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX187TbJhvu47/fKBNIINclsnPH2Lwa6p55yUqd9Kqt
	KyHYQtNvK2Txis
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arun Thomas <arun.thomas@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/comedi/icp_multi: fix sparse warning "obsolete struct initializer"
Date: Mon, 10 Jan 2011 23:18:33 +0100
Message-Id: <1294697913-14467-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sparse warnings
"obsolete struct initializer, use C99 syntax" in icp_multi.c
by converting the struct to C99 syntax

KernelVersion: linux-next-20110110

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/icp_multi.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 809d17e..0bab39b 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -176,13 +176,13 @@ static const struct boardtype boardtypes[] = {
 #define n_boardtypes (sizeof(boardtypes)/sizeof(struct boardtype))
 
 static struct comedi_driver driver_icp_multi = {
-driver_name: "icp_multi",
-module : THIS_MODULE,
-attach : icp_multi_attach,
-detach : icp_multi_detach,
-num_names : n_boardtypes,
-board_name : &boardtypes[0].name,
-offset : sizeof(struct boardtype),
+	.driver_name = "icp_multi",
+	.module = THIS_MODULE,
+	.attach = icp_multi_attach,
+	.detach = icp_multi_detach,
+	.num_names = n_boardtypes,
+	.board_name = &boardtypes[0].name,
+	.offset = sizeof(struct boardtype),
 };
 
 static int __init driver_icp_multi_init_module(void)
-- 
1.7.2.2

