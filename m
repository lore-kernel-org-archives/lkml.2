Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0EJK52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:57:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:59639 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643Ab0EJK50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:57:26 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, tglx@linuxtronix.de, mingo@elte.hu,
       davem@davemloft.net, lethal@linux-sh.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 10/25] lmb: Remove unused lmb.debug struct member
Date: Mon, 10 May 2010 19:38:44 +1000
Message-Id: <1273484339-28911-11-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273484339-28911-10-git-send-email-benh@kernel.crashing.org>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-2-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-3-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-5-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-6-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-7-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-8-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-9-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-10-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/lmb.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 042250c..5fdd900 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -32,7 +32,6 @@ struct lmb_type {
 };
 
 struct lmb {
-	unsigned long debug;
 	phys_addr_t current_limit;
 	struct lmb_type memory;
 	struct lmb_type reserved;
@@ -55,9 +54,11 @@ extern phys_addr_t __init lmb_alloc(phys_addr_t size, phys_addr_t align);
 #define LMB_ALLOC_ACCESSIBLE	0
 
 extern phys_addr_t __init lmb_alloc_base(phys_addr_t size,
-		phys_addr_t, phys_addr_t max_addr);
+					 phys_addr_t align,
+					 phys_addr_t max_addr);
 extern phys_addr_t __init __lmb_alloc_base(phys_addr_t size,
-		phys_addr_t align, phys_addr_t max_addr);
+					   phys_addr_t align,
+					   phys_addr_t max_addr);
 extern phys_addr_t __init lmb_phys_mem_size(void);
 extern phys_addr_t lmb_end_of_DRAM(void);
 extern void __init lmb_enforce_memory_limit(phys_addr_t memory_limit);
-- 
1.6.3.3

