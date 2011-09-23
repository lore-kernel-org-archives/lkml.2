Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1IWW0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:26:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3848 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1IWW0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:26:22 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [RFD 9/9] Change CPUACCT to default n
Date: Fri, 23 Sep 2011 19:20:32 -0300
Message-Id: <1316816432-9237-10-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we're providing all cpuacct capability in cpu cgroup,
default CPUACCT to n. We still maintain it for compatiblity for
anyone that need an independent set of tasks to be managed by it
relatively to cpu cgroup, but encourage the use of cpucgroup for that.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Balbir Singh <bsingharora@gmail.com>
---
 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index d627783..891d6c1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -626,6 +626,7 @@ config PROC_PID_CPUSET
 
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
+	default n
 	help
 	  Provides a simple Resource Controller for monitoring the
 	  total CPU consumed by the tasks in a cgroup.
-- 
1.7.6

