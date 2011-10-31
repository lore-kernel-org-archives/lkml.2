Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab1JaTaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:30:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35282 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1JaTaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:30:04 -0400
From: Ciaran McCormick <ciaranmccormick@gmail.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, Ciaran McCormick <ciaranmccormick@gmail.com>
Subject: [PATCH] dma: fix spacing for method declaration, coding style issue in iop-adma.c
Date: Mon, 31 Oct 2011 19:29:26 +0000
Message-Id: <1320089366-13300-1-git-send-email-ciaranmccormick@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Signed-off-by: Ciaran McCormick <ciaranmccormick@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ciaran McCormick <ciaranmccormick@gmail.com>

---
 drivers/dma/iop-adma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index e03f811..686dc76 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1746,12 +1746,12 @@ static struct platform_driver iop_adma_driver = {
 	},
 };
 
-static int __init iop_adma_init (void)
+static int __init iop_adma_init(void)
 {
 	return platform_driver_register(&iop_adma_driver);
 }
 
-static void __exit iop_adma_exit (void)
+static void __exit iop_adma_exit(void)
 {
 	platform_driver_unregister(&iop_adma_driver);
 	return;
-- 
1.7.5.4

