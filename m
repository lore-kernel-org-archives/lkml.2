Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1E0Ves (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:34:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59992 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1E0Ver (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:34:47 -0400
Date: Fri, 27 May 2011 14:34:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH] mm: fix memory.c kernel-doc notation
Message-Id: <20110527143408.891022e0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4DE018F4.0086:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc warnings in mm/memory.c:

Warning(mm/memory.c:1327): No description found for parameter 'tlb'
Warning(mm/memory.c:1327): Excess function parameter 'tlbp' description in 'unmap_vmas'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.39-git14.orig/mm/memory.c
+++ linux-2.6.39-git14/mm/memory.c
@@ -1296,7 +1296,7 @@ static unsigned long unmap_page_range(st
 
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
- * @tlbp: address of the caller's struct mmu_gather
+ * @tlb: address of the caller's struct mmu_gather
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
