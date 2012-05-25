Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2EYGvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:51:15 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51675 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2EYGvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:51:12 -0400
Message-ID: <4FBF29E7.5020805@ct.jp.nec.com>
Date: Fri, 25 May 2012 15:42:47 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] sched: Remove the last NULL entry from sched_feat_names
References: <4FBF29B2.9030904@ct.jp.nec.com>
In-Reply-To: <4FBF29B2.9030904@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

No need to have the last NULL entry.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8e595a..621b10c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -144,7 +144,6 @@ const_debug unsigned int sysctl_sched_features =
 
 static const char * const sched_feat_names[] = {
 #include "features.h"
-	NULL
 };
 
 #undef SCHED_FEAT
-- 
1.7.7.6

