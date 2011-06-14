Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1FNWhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:37:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FNWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:36:59 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=L1bM8_oMYDMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=TGv66S21RaarJqEcnTcA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110614223623.876681637@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Jun 2011 18:36:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL][v3.0] sched: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/sched/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git
tip/sched/urgent

Head SHA1: 349d467dc2c8d22df6a891562843bb7d8409f93f


Hillf Danton (1):
      sched: Fix need_resched() when checking peempt

Steven Rostedt (1):
      sched: Check if lowest_mask is initialized in find_lowest_rq

----
 kernel/sched_rt.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)
