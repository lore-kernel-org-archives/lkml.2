Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0JVH11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:27:27 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:49418 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0JVH10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:27:26 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 19/30] staging/vme/ca91cx42: mark the registers' base address pointer as __iomem
Date: Fri, 22 Oct 2010 02:36:41 -0400
Message-Id: <1287729412-24356-20-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
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

