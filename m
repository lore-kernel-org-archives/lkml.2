Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2HFHcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 03:32:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34566 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2HFHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 03:32:12 -0400
From: Zhouping Liu <sanweidaying@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>, Zhouping Liu <sanweidaying@gmail.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH] hugetlb: update hugetlbpage.txt
Date: Mon,  6 Aug 2012 15:26:30 +0800
Message-Id: <1344237996-8769-1-git-send-email-sanweidaying@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f0f57b2b1(mm: move hugepage test examples to tools/testing/selftests/vm)
moved map_hugetlb.c, hugepage-shm.c and hugepage-mmap.c tests into
tools/testing/selftests/vm/ directory, but it didn't update hugetlbpage.txt

Signed-off-by: Zhouping Liu <sanweidaying@gmail.com>
---
 Documentation/vm/hugetlbpage.txt | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
index f8551b3..4ac359b 100644
--- a/Documentation/vm/hugetlbpage.txt
+++ b/Documentation/vm/hugetlbpage.txt
@@ -299,11 +299,17 @@ map_hugetlb.c.
 *******************************************************************
 
 /*
- * hugepage-shm:  see Documentation/vm/hugepage-shm.c
+ * map_hugetlb: see tools/testing/selftests/vm/map_hugetlb.c
  */
 
 *******************************************************************
 
 /*
- * hugepage-mmap:  see Documentation/vm/hugepage-mmap.c
+ * hugepage-shm:  see tools/testing/selftests/vm/hugepage-shm.c
+ */
+
+*******************************************************************
+
+/*
+ * hugepage-mmap:  see tools/testing/selftests/vm/hugepage-mmap.c
  */
-- 
1.7.11.2

