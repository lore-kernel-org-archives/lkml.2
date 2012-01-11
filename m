Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2AKH0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:26:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab2AKHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:25:57 -0500
Date: Tue, 10 Jan 2012 23:25:28 -0800
From: tip-bot for Fabio Estevam <festevam@gmail.com>
Message-ID: <tip-6db9dc150eabce7053c8df2a2146aa0d6748ec42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fabio.estevam@freescale.com, tglx@linutronix.de, mingo@elte.hu,
        festevam@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fabio.estevam@freescale.com, tglx@linutronix.de, festevam@gmail.com,
        mingo@elte.hu
In-Reply-To: <1326192383-5113-1-git-send-email-festevam@gmail.com>
References: <1326192383-5113-1-git-send-email-festevam@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix CONFIG_CGROUP_SCHED dependency
Git-Commit-ID: 6db9dc150eabce7053c8df2a2146aa0d6748ec42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 10 Jan 2012 23:25:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6db9dc150eabce7053c8df2a2146aa0d6748ec42
Gitweb:     http://git.kernel.org/tip/6db9dc150eabce7053c8df2a2146aa0d6748ec42
Author:     Fabio Estevam <festevam@gmail.com>
AuthorDate: Tue, 10 Jan 2012 08:46:23 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Jan 2012 13:44:50 +0100

sched: Fix CONFIG_CGROUP_SCHED dependency

The dependency bug was pointed out by this build warning:

 warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: a.p.zijlstra@chello.nl
Cc: Fabio Estevam <festevam@gmail.com>
Link: http://lkml.kernel.org/r/1326192383-5113-1-git-send-email-festevam@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 82b6a4c..a34cd17 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -702,7 +702,6 @@ config CGROUP_PERF
 
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
-	depends on EXPERIMENTAL
 	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
