Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2INRN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:13:29 -0400
Received: from mxout1.idt.com ([157.165.5.25]:51453 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2INRN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:13:27 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] rapidio: fix kerneldoc warnings after DMA support was added
Date: Fri, 14 Sep 2012 13:11:35 -0400
Message-Id: <1347642695-28549-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Robert P. J. Day <rpjday@crashcourse.ca>
---
 include/linux/rio.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/rio.h b/include/linux/rio.h
index 1a7b6c7..ba382f2 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -236,6 +236,7 @@ enum rio_phy_type {
  * @phys_efptr: RIO port extended features pointer
  * @name: Port name string
  * @priv: Master port private data
+ * @dma: DMA device associated with mport
  */
 struct rio_mport {
 	struct list_head dbells;	/* list of doorbell events */
@@ -404,7 +405,7 @@ union rio_pw_msg {
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
-/**
+/*
  * enum rio_write_type - RIO write transaction types used in DMA transfers
  *
  * Note: RapidIO specification defines write (NWRITE) and
-- 
1.7.8.4

