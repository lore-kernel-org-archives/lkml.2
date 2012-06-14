Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2FNDrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:47:48 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48733 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2FNDrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:47:47 -0400
Message-ID: <1339645650.12607.9.camel@ThinkPad-T420>
Subject: [PATCH][TRIVIAL] Fix comments in mm/memblock.c
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: trivial@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Jun 2012 11:47:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12061403-4790-0000-0000-00000339EAFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the parameter names in comments consistent with the actual ones
used in the function.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mm/memblock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 952123e..76cb09f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -540,9 +540,9 @@ int __init_memblock memblock_reserve(phys_addr_t
base, phys_addr_t size)
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
  * @nid: nid: node selector, %MAX_NUMNODES for all nodes
- * @p_start: ptr to phys_addr_t for start address of the range, can be
%NULL
- * @p_end: ptr to phys_addr_t for end address of the range, can be %
NULL
- * @p_nid: ptr to int for nid of the range, can be %NULL
+ * @out_start: ptr to phys_addr_t for start address of the range, can
be %NULL
+ * @out_end: ptr to phys_addr_t for end address of the range, can be %
NULL
+ * @out_nid: ptr to int for nid of the range, can be %NULL
  *
  * Find the first free area from *@idx which matches @nid, fill the out
  * parameters, and update *@idx for the next iteration.  The lower
32bit of
-- 
1.7.9.5

