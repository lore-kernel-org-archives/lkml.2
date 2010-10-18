Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0JRMqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:46:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52105 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab0JRMqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=GhRweCAwTKnnb9+TsN4amjo12F1faoqY+ZTKMNO8PuNmQcmsBLzVBd3i50gD+b2MyQ
         7Xn/mDrfpCokRNtfFf/eCA7dL6ciSE86ntYE5/+/9zRcLfkd89JR2DjpvqoFwYl2JY2G
         0wEntM196r8yQqSPL91KZNkJZiDErAnU7Zxyk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 07/12] mm: fixed typos
Date: Mon, 18 Oct 2010 14:46:01 +0200
Message-Id: <1287405961-5664-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.3.1.181.g784b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 mm/percpu.c |    2 +-
 mm/vmscan.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index c76ef38..8b9aa45 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -31,7 +31,7 @@
  * as small as 4 bytes.  The allocator organizes chunks into lists
  * according to free size and tries to allocate from the fullest one.
  * Each chunk keeps the maximum contiguous area size hint which is
- * guaranteed to be eqaul to or larger than the maximum contiguous
+ * guaranteed to be equal to or larger than the maximum contiguous
  * area in the chunk.  This helps the allocator not to iterate the
  * chunk maps unnecessarily.
  *
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c5dfabf..08823c4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -79,7 +79,7 @@ struct scan_control {
 	int order;
 
 	/*
-	 * Intend to reclaim enough contenious memory rather than to reclaim
+	 * Intend to reclaim enough contiguous memory rather than to reclaim
 	 * enough amount memory. I.e, it's the mode for high order allocation.
 	 */
 	bool lumpy_reclaim_mode;
-- 
1.7.3.1.181.g784b8

