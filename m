Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1BBUrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:47:39 -0500
Received: from shutemov.name ([188.40.19.243]:37803 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab1BBUri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:47:38 -0500
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v3 0/2] Timer slack cgroup subsystem
Date: Wed,  2 Feb 2011 22:47:34 +0200
Message-Id: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Changelog:
v3: 
 - rework interface
 - s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/
v2:
 - fixed with CONFIG_CGROUP_TIMER_SLACK=y
v1:
 - initial revision

Kirill A. Shutemov (2):
  cgroups: export cgroup_iter_{start,next,end}
  cgroups: introduce timer slack subsystem

 include/linux/cgroup_subsys.h |    6 +
 include/linux/init_task.h     |    4 +-
 init/Kconfig                  |   10 ++
 kernel/Makefile               |    1 +
 kernel/cgroup.c               |    3 +
 kernel/cgroup_timer_slack.c   |  242 +++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                  |   24 +++-
 7 files changed, 283 insertions(+), 7 deletions(-)
 create mode 100644 kernel/cgroup_timer_slack.c

-- 
1.7.3.5

