Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1FLVcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 17:32:25 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:34734 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab1FLVcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 17:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition;
        b=HlSiF3f/P+7wo+PRUA3+QBp7uQ/tfsH68T35C6tmq6B7SLMhf1iDkNHC/A8Cy3eAIH
         gJ23dA/SGDV6TT7Stg49o/BgzDGoFt+6dDQkOIl1A0rj9HorTqiVVXoswKL+yvj0nFDp
         OUVWKgTfOa+DtRIDbQ8hTnpJaRd/XzbZ9PB1g=
Date: Sun, 12 Jun 2011 15:31:07 -0600
From: Jean Sacren <sakiwit@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] kernel/sched.c: Fix array initialization typo
Message-ID: <20110612213107.GA12816@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix makes certain so that the size of the initialized arrays doesn't
go beyond the boundary set by the array size of 40.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c164920..c29ddd0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1383,7 +1383,7 @@ static const int prio_to_weight[40] = {
  /*   0 */      1024,       820,       655,       526,       423,
  /*   5 */       335,       272,       215,       172,       137,
  /*  10 */       110,        87,        70,        56,        45,
- /*  15 */        36,        29,        23,        18,        15,
+ /*  15 */        36,        29,        23,        18,        15
 };
 
 /*
@@ -1401,7 +1401,7 @@ static const u32 prio_to_wmult[40] = {
  /*   0 */   4194304,   5237765,   6557202,   8165337,  10153587,
  /*   5 */  12820798,  15790321,  19976592,  24970740,  31350126,
  /*  10 */  39045157,  49367440,  61356676,  76695844,  95443717,
- /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
+ /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153
 };
 
 /* Time spent by the tasks of the cpu accounting group executing in ... */
-- 
1.7.2.2

-- 
Jean Sacren
