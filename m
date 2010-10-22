Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0JVHbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:31:36 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:47486 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0JVHbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:31:35 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 18/30] staging/vme/tsi148: mark the registers' base address pointer as __iomem
Date: Fri, 22 Oct 2010 02:36:40 -0400
Message-Id: <1287729412-24356-19-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_tsi148.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.h b/drivers/staging/vme/bridges/vme_tsi148.h
index bda64ef..9f97fa8 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.h
+++ b/drivers/staging/vme/bridges/vme_tsi148.h
@@ -35,7 +35,7 @@
 
 /* Structure used to hold driver specific information */
 struct tsi148_driver {
-	void *base;	/* Base Address of device registers */
+	void __iomem *base;	/* Base Address of device registers */
 	wait_queue_head_t dma_queue[2];
 	wait_queue_head_t iack_queue;
 	void (*lm_callback[4])(int);	/* Called in interrupt handler */
-- 
1.7.1

