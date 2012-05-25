Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2EYGvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:51:02 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62582 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2EYGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:51:00 -0400
Message-ID: <4FBF29B2.9030904@ct.jp.nec.com>
Date: Fri, 25 May 2012 15:41:54 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] sched: Make sched_feat_names const
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The strings sched_feat_names are never changed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fdf8f98..e8e595a 100644
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
-- 
1.7.7.6

