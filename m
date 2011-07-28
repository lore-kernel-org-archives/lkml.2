Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1G1XJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:09:58 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:38918 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab1G1XJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:09:56 -0400
From: jhbird.choi@samsung.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] mm/memblock: small function definition fixes
Date: Fri, 29 Jul 2011 08:01:20 +0900
Message-Id: <1311894080-10231-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

warning: function 'memblock_memory_can_coalesce'
with external linkage has definition.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index ccbf973..3314cb4 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -267,7 +267,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	return 0;
 }
 
-extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
+int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
 					  phys_addr_t addr2, phys_addr_t size2)
 {
 	return 1;
-- 
1.7.0

