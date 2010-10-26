Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0JZBMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:12 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:41243 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0JZBMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:10 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 19/30] staging/vme/ca91cx42: mark the registers' base address pointer as __iomem
Date: Mon, 25 Oct 2010 21:11:05 -0400
Message-Id: <1288055476-19438-20-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_ca91cx42.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.h b/drivers/staging/vme/bridges/vme_ca91cx42.h
index e72c65b..02a7c79 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.h
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.h
@@ -39,7 +39,7 @@
 
 /* Structure used to hold driver specific information */
 struct ca91cx42_driver {
-	void *base;	/* Base Address of device registers */
+	void __iomem *base;	/* Base Address of device registers */
 	wait_queue_head_t dma_queue;
 	wait_queue_head_t iack_queue;
 	wait_queue_head_t mbox_queue;
-- 
1.7.1

