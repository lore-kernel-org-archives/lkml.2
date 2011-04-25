Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab1DYJjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:39:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43613 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab1DYJjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:39:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: cpumask: convert for_each_cpumask() with for_each_cpu()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110425184051.2696.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 18:39:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adapt new API fashion.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 lib/cpumask.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index 05d6aca..4f6425d 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -30,7 +30,7 @@ int __any_online_cpu(const cpumask_t *mask)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		if (cpu_online(cpu))
 			break;
 	}
-- 
1.7.3.1



