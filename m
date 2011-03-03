Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab1CCOTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:19:11 -0500
Received: from shutemov.name ([188.40.19.243]:53698 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab1CCOTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:19:09 -0500
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v8 0/3] *** SUBJECT HERE ***
Date: Thu,  3 Mar 2011 16:19:04 +0200
Message-Id: <1299161947-9903-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

*** BLURB HERE ***

Kirill A. Shutemov (3):
  hrtimer: introduce effective timer slack
  hrtimer: implement PR_GET_EFFECTIVE_TIMERSLACK
  cgroups: introduce timer slack controller

 Documentation/cgroups/timer_slack.txt |   64 +++++++++++++++++
 fs/select.c                           |    7 +--
 include/linux/cgroup_subsys.h         |    6 ++
 include/linux/prctl.h                 |    6 ++
 include/linux/sched.h                 |   10 +++
 init/Kconfig                          |    8 ++
 kernel/Makefile                       |    1 +
 kernel/cgroup_timer_slack.c           |  124 +++++++++++++++++++++++++++++++++
 kernel/fork.c                         |    4 +
 kernel/futex.c                        |    4 +-
 kernel/hrtimer.c                      |    2 +-
 kernel/sys.c                          |    3 +
 12 files changed, 231 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/cgroups/timer_slack.txt
 create mode 100644 kernel/cgroup_timer_slack.c

-- 
1.7.4.1

