Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1EPURJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:17:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37607 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1EPURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:17:07 -0400
Date: Mon, 16 May 2011 13:16:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] mm: fix kernel-doc warning in page_alloc.c
Message-Id: <20110516131654.c8aa74bd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DD18641.0020:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc warning in mm/page_alloc.c:

Warning(mm/page_alloc.c:2370): No description found for parameter 'nid'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.39-rc7-git10.orig/mm/page_alloc.c
+++ linux-2.6.39-rc7-git10/mm/page_alloc.c
@@ -2358,6 +2358,7 @@ EXPORT_SYMBOL(alloc_pages_exact);
 /**
  * alloc_pages_exact_nid - allocate an exact number of physically-contiguous
  *			   pages on a node.
+ * @nid: the preferred node ID where memory should be allocated
  * @size: the number of bytes to allocate
  * @gfp_mask: GFP flags for the allocation
  *
