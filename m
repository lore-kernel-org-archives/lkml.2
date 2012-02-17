Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2BQOcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:32:04 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37397
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2BQOcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:32:01 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix typo in unevictable-lru.txt
Date: Fri, 17 Feb 2012 23:31:31 +0900
Message-Id: <1329489091-2204-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "semphore" to "semaphore" in
Documentation/vm/unevictable-lru.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/vm/unevictable-lru.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/unevictable-lru.txt b/Documentation/vm/unevictable-lru.txt
index 97bae3c..609d1a3 100644
--- a/Documentation/vm/unevictable-lru.txt
+++ b/Documentation/vm/unevictable-lru.txt
@@ -538,7 +538,7 @@ different reverse map mechanisms.
      process because mlocked pages are migratable.  However, for reclaim, if
      the page is mapped into a VM_LOCKED VMA, the scan stops.
 
-     try_to_unmap_anon() attempts to acquire in read mode the mmap semphore of
+     try_to_unmap_anon() attempts to acquire in read mode the mmap semaphore of
      the mm_struct to which the VMA belongs.  If this is successful, it will
      mlock the page via mlock_vma_page() - we wouldn't have gotten to
      try_to_unmap_anon() if the page were already mlocked - and will return
@@ -623,7 +623,7 @@ mapped file pages with an additional argument specifing unlock versus unmap
 processing.  Again, these functions walk the respective reverse maps looking
 for VM_LOCKED VMAs.  When such a VMA is found for anonymous pages and file
 pages mapped in linear VMAs, as in the try_to_unmap() case, the functions
-attempt to acquire the associated mmap semphore, mlock the page via
+attempt to acquire the associated mmap semaphore, mlock the page via
 mlock_vma_page() and return SWAP_MLOCK.  This effectively undoes the
 pre-clearing of the page's PG_mlocked done by munlock_vma_page.
 
@@ -641,7 +641,7 @@ with it - the usual fallback position.
 Note that try_to_munlock()'s reverse map walk must visit every VMA in a page's
 reverse map to determine that a page is NOT mapped into any VM_LOCKED VMA.
 However, the scan can terminate when it encounters a VM_LOCKED VMA and can
-successfully acquire the VMA's mmap semphore for read and mlock the page.
+successfully acquire the VMA's mmap semaphore for read and mlock the page.
 Although try_to_munlock() might be called a great many times when munlocking a
 large region or tearing down a large address space that has been mlocked via
 mlockall(), overall this is a fairly rare event.
-- 
1.7.6.5

