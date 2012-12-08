Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2LHGCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 01:02:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56407 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2LHGCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 01:02:45 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] Documentation: cgroup: update the index file
Date: Sat,  8 Dec 2012 15:02:36 +0900
Message-Id: <1354946557-7938-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

There are new files added to cgroup documentation. Lets
update the index file listing all the remaining files

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 Documentation/cgroups/00-INDEX |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/cgroups/00-INDEX b/Documentation/cgroups/00-INDEX
index 3f58fa3..f78b90a 100644
--- a/Documentation/cgroups/00-INDEX
+++ b/Documentation/cgroups/00-INDEX
@@ -1,7 +1,11 @@
 00-INDEX
 	- this file
+blkio-controller.txt
+	- Description for Block IO Controller, implementation and usage details.
 cgroups.txt
 	- Control Groups definition, implementation details, examples and API.
+cgroup_event_listener.c
+	- A user program for cgroup listener.
 cpuacct.txt
 	- CPU Accounting Controller; account CPU usage for groups of tasks.
 cpusets.txt
@@ -10,9 +14,13 @@ devices.txt
 	- Device Whitelist Controller; description, interface and security.
 freezer-subsystem.txt
 	- checkpointing; rationale to not use signals, interface.
+hugetlb.txt
+	- HugeTLB Controller implementation and usage details.
 memcg_test.txt
 	- Memory Resource Controller; implementation details.
 memory.txt
 	- Memory Resource Controller; design, accounting, interface, testing.
+net_prio.txt
+	- Network priority cgroups details and usages.
 resource_counter.txt
 	- Resource Counter API.
-- 
1.7.9.5

