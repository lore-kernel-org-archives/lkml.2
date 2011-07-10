Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1GJJGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:06:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33368 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab1GJJGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:06:05 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Paul Menage <menage@google.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] Doc:cgroup:fix a cpuset's file description in cpusets.txt
Date: Sun, 10 Jul 2011 16:58:33 +0800
Message-Id: <1310288313-4908-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only the root cpuset has cpuset.memory_pressure_enabled flag,
but not the only one.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 Documentation/cgroups/cpusets.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 5b0d78e..5c51ed4 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -180,7 +180,7 @@ files describing that cpuset:
  - cpuset.sched_load_balance flag: if set, load balance within CPUs on that cpuset
  - cpuset.sched_relax_domain_level: the searching range when migrating tasks
 
-In addition, the root cpuset only has the following file:
+In addition, only the root cpuset has the following file:
  - cpuset.memory_pressure_enabled flag: compute memory_pressure?
 
 New cpusets are created using the mkdir system call or shell
-- 
1.7.4.1

