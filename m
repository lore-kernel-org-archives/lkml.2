Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab2E3Nlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:41:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2E3Nlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:41:45 -0400
Date: Wed, 30 May 2012 06:41:27 -0700
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Message-ID: <tip-1292531f6f27af909e713671dd9cc3bcab8114b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <4FBF29B2.9030904@ct.jp.nec.com>
References: <4FBF29B2.9030904@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Make sched_feat_names const
Git-Commit-ID: 1292531f6f27af909e713671dd9cc3bcab8114b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:41:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1292531f6f27af909e713671dd9cc3bcab8114b7
Gitweb:     http://git.kernel.org/tip/1292531f6f27af909e713671dd9cc3bcab8114b7
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Fri, 25 May 2012 15:41:54 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:26 +0200

sched: Make sched_feat_names const

The strings sched_feat_names are never changed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FBF29B2.9030904@ct.jp.nec.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 70cc36a..c1679a0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -142,7 +142,7 @@ const_debug unsigned int sysctl_sched_features =
 #define SCHED_FEAT(name, enabled)	\
 	#name ,
 
-static __read_mostly char *sched_feat_names[] = {
+static const char * const sched_feat_names[] = {
 #include "features.h"
 	NULL
 };
