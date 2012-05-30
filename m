Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2E3Nmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:42:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2E3Nmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:42:35 -0400
Date: Wed, 30 May 2012 06:42:19 -0700
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Message-ID: <tip-7997a456ef841bb78eb6f881d7cc2c17c2f9b35e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <4FBF29E7.5020805@ct.jp.nec.com>
References: <4FBF29E7.5020805@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Remove the last NULL entry from sched_feat_names
Git-Commit-ID: 7997a456ef841bb78eb6f881d7cc2c17c2f9b35e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:42:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7997a456ef841bb78eb6f881d7cc2c17c2f9b35e
Gitweb:     http://git.kernel.org/tip/7997a456ef841bb78eb6f881d7cc2c17c2f9b35e
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Fri, 25 May 2012 15:42:47 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:27 +0200

sched: Remove the last NULL entry from sched_feat_names

No need to have the last NULL entry.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FBF29E7.5020805@ct.jp.nec.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1679a0..94d598a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -144,7 +144,6 @@ const_debug unsigned int sysctl_sched_features =
 
 static const char * const sched_feat_names[] = {
 #include "features.h"
-	NULL
 };
 
 #undef SCHED_FEAT
