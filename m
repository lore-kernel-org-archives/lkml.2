Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0IJE0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 00:26:42 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40185 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0IJE0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 00:26:38 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
Subject: [PATCH 0/4] hugetlb, rmap: fixes and cleanups
Date: Fri, 10 Sep 2010 13:23:02 +0900
Message-Id: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are fix and cleanup patches for hugepage rmapping.
All these were pointed out in the following thread (last 4 messages.)

  http://thread.gmane.org/gmane.linux.kernel.mm/52334

Summary:

 [PATCH 1/4] hugetlb, rmap: always use anon_vma root pointer
 [PATCH 2/4] hugetlb, rmap: use hugepage_add_new_anon_rmap() in hugetlb_cow()
 [PATCH 3/4] hugetlb, rmap: fix confusing page locking in hugetlb_cow()
 [PATCH 4/4] hugetlb, rmap: add BUG_ON(!PageLocked) in hugetlb_add_anon_rmap()

Thanks,
Naoya Horiguchi
