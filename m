Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2DEQsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:48:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37834 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2DEQsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:48:32 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] Documentation: mm: Add compact_node on Documentation/sysctl/vm.txt
Date: Fri,  6 Apr 2012 01:48:08 +0900
Message-Id: <1333644489-31466-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Documentation/sysctl/vm.txt does include "compact_memory",
but it doesn't include "compact_node".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/sysctl/vm.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 9c11d97..c94acad 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -20,6 +20,7 @@ Currently, these files are in /proc/sys/vm:
 
 - block_dump
 - compact_memory
+- compact_node
 - dirty_background_bytes
 - dirty_background_ratio
 - dirty_bytes
@@ -76,6 +77,13 @@ huge pages although processes will also directly compact memory as required.
 
 ==============================================================
 
+compact_node
+
+Available only when CONFIG_COMPACTION is set and also the system is NUMA
+architecture. When a node number is written to the file, the kernel fixing
+the fragmented pages on the specified NUMA node. 
+
+==============================================================
 dirty_background_bytes
 
 Contains the amount of dirty memory at which the pdflush background writeback
-- 
1.7.10.rc4

