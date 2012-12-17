Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab2LQDng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:43:36 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37862 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2LQDnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:43:35 -0500
MIME-Version: 1.0
Date: Mon, 17 Dec 2012 11:43:34 +0800
Message-ID: <CA+U0gVi3d1FQ-jdt6_Jd15rY-QYLjfHu91pTsJQp1TFqhxzWBQ@mail.gmail.com>
Subject: No cpu.cfs_period_us & cpu.cfs_quota_us controller found in Linux
 kernel 3.5.1
From: Dennis Chen <kernel.org.gnu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

I build a 3.5.1 kernel with below configuration snippet:

...
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
...

But when I start to use this new build kernel with ubuntu 12.10
distribution, and install the cgroup with #apt-get install cgroup-bin,
after that, I can't find cpu.cfs_period_us and cpu.cfs_quota_us in the
/sys/fs/cgroup/cpu folder.

Is there some one encounter the similar scenario as mine or some hints
about this?

Thanks
