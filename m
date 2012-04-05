Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2DEQsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:48:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42025 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2DEQsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:48:35 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] Documentation: mm: Fix path to extfrag_index in vm.txt
Date: Fri,  6 Apr 2012 01:48:09 +0900
Message-Id: <1333644489-31466-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc4
In-Reply-To: <1333644489-31466-1-git-send-email-standby24x7@gmail.com>
References: <1333644489-31466-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The path for extfrag_index has not been updated even after it moved
to under /sys. This patch fixed the path.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/sysctl/vm.txt |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index c94acad..9dd8555 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -166,11 +166,12 @@ user should run `sync' first.
 extfrag_threshold
 
 This parameter affects whether the kernel will compact memory or direct
-reclaim to satisfy a high-order allocation. /proc/extfrag_index shows what
-the fragmentation index for each order is in each zone in the system. Values
-tending towards 0 imply allocations would fail due to lack of memory,
-values towards 1000 imply failures are due to fragmentation and -1 implies
-that the allocation will succeed as long as watermarks are met.
+reclaim to satisfy a high-order allocation. 
+/sys/kernel/debug/extfrag/extfrag_index shows what the fragmentation index 
+for each order is in each zone in the system. Values tending towards 0 
+imply allocations would fail due to lack of memory, values towards 1000 
+imply failures are due to fragmentation and -1 implies that the allocation 
+will succeed as long as watermarks are met.
 
 The kernel will not compact memory in a zone if the
 fragmentation index is <= extfrag_threshold. The default value is 500.
-- 
1.7.10.rc4

