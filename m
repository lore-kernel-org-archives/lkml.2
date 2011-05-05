Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1EEIwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:52:24 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:63817 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1EEIwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PLbCN8C5v82MZOIa0bTJN/x58PClo6qsNK+FWMgrmH6jtb1c4pqIr6y/RF2EM3wk2c
         AmGfjfied+0Q6Hhp+itbGYeKOzp13RNj6qlpbfzDE+5L6EFvOohv1mfB/Nwi/X+QrPyc
         gap3IXryezmEYip+YNhmCi3L7QfziJ0B/90a4=
From: Robin Dong <hao.bigrat@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] mm: change incorrect 'extern' keyword to 'static'
Date: Thu,  5 May 2011 16:51:58 +0800
Message-Id: <1304585518-9665-3-git-send-email-sanbai@taobao.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304585518-9665-1-git-send-email-sanbai@taobao.com>
References: <1304585518-9665-1-git-send-email-sanbai@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change function memblock_memory_can_coalesce from 'extern' to 'static' to
match the memblock_* series function.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 400dc62..9570c43 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -292,7 +292,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	return 0;
 }
 
-extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
+static int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
 					  phys_addr_t addr2, phys_addr_t size2)
 {
 	return 1;
-- 
1.7.1

