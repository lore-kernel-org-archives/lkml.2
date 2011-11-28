Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1K1Qqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:46:35 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:20792 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1K1Qqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:46:34 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH v2 0/3] cpuacct cgroup refactoring
Date: Mon, 28 Nov 2011 14:45:16 -0200
Message-Id: <1322498719-2255-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the same series I've already sent before. Just sending again
after the conflict with the code that was in tip.git

Best regards,

Glauber Costa (3):
  Change cpustat fields to an array.
  Reuse cgroup's parent pointer
  cpuacct.stat: re-use scheduler statistics for the root cgroup

 arch/s390/appldata/appldata_os.c       |   16 +-
 arch/x86/include/asm/i387.h            |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   38 +++---
 drivers/cpufreq/cpufreq_ondemand.c     |   38 +++---
 drivers/macintosh/rack-meter.c         |    8 +-
 fs/proc/stat.c                         |   63 ++++-----
 fs/proc/uptime.c                       |    4 +-
 include/linux/kernel_stat.h            |   36 +++--
 kernel/sched/core.c                    |  242 +++++++++++++++----------------
 kernel/sched/sched.h                   |   33 ++++-
 10 files changed, 248 insertions(+), 232 deletions(-)

-- 
1.7.6.4

