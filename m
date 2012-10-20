Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab2JTTG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:06:28 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:54190 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2JTTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:06:26 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com A1A1983305
From: Andrea Righi <andrea@betterlinux.com>
To: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrea Righi <andrea@betterlinux.com>
Subject: [PATCH v2 3/3] cpusets: add documentation of the loadavg file
Date: Sat, 20 Oct 2012 21:06:02 +0200
Message-Id: <1350759962-7092-4-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
References: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 Documentation/cgroups/cpusets.txt |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index cefd3d8..d5ddc36 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -179,6 +179,7 @@ files describing that cpuset:
  - cpuset.memory_spread_slab flag: if set, spread slab cache evenly on allowed nodes
  - cpuset.sched_load_balance flag: if set, load balance within CPUs on that cpuset
  - cpuset.sched_relax_domain_level: the searching range when migrating tasks
+ - cpuset.loadavg: the load average of the CPUs in that cpuset
 
 In addition, only the root cpuset has the following file:
  - cpuset.memory_pressure_enabled flag: compute memory_pressure?
-- 
1.7.10.4

