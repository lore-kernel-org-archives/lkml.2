Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab1KVDoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:44:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61609 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1KVDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:44:37 -0500
From: Zhu Yanhai <zhu.yanhai@gmail.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>
Subject: [PATCH] Fix a typo in memcontroller's documention
Date: Tue, 22 Nov 2011 11:48:02 +0800
Message-Id: <1321933682-2843-1-git-send-email-gaoyang.zyh@taobao.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be memsw.max_usage_in_bytes. This typo has been there for
really a long time.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
---
 Documentation/cgroups/memory.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index cc0ebc5..0f6b0f3 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -61,7 +61,7 @@ Brief summary of control files.
  memory.failcnt			 # show the number of memory usage hits limits
  memory.memsw.failcnt		 # show the number of memory+Swap hits limits
  memory.max_usage_in_bytes	 # show max memory usage recorded
- memory.memsw.usage_in_bytes	 # show max memory+Swap usage recorded
+ memory.memsw.max_usage_in_bytes # show max memory+Swap usage recorded
  memory.soft_limit_in_bytes	 # set/show soft limit of memory usage
  memory.stat			 # show various statistics
  memory.use_hierarchy		 # set/show hierarchical account enabled
-- 
1.7.4.4

