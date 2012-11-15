Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab2KOWcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:32:19 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56973 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2KOWcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:32:18 -0500
Date: Thu, 15 Nov 2012 14:32:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [patch] thp: copy_huge_pmd(): copy huge zero page v6 fix
In-Reply-To: <1353007622-18393-4-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211151431280.27188@chino.kir.corp.google.com>
References: <1353007622-18393-1-git-send-email-kirill.shutemov@linux.intel.com> <1353007622-18393-4-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix comment

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/huge_memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -791,7 +791,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		goto out_unlock;
 	}
 	/*
-	 * mm->pagetable lock is enough to be sure that huge zero pmd is not
+	 * mm->page_table_lock is enough to be sure that huge zero pmd is not
 	 * under splitting since we don't split the page itself, only pmd to
 	 * a page table.
 	 */
