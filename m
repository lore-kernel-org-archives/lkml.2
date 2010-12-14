Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab0LNB3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:29:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab0LNB2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:28:46 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=3r_QUscyLaIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=1KJz91xA7ZKxkHfk4-IA:9 a=eKVdZJjLvMNtmcGAQjYA:7 a=EleliQl0UBcRq-gTjPSf3ph98UMA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214012803.142630411@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 20:28:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/4] [GIT PULL] sched: Remove unlikely likelys
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest unlikely/sched tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
unlikely/sched


Steven Rostedt (3):
      sched: Change pick_next_task_rt from unlikely to likely
      sched: Remove unlikely() from rt_policy() in sched.c
      sched: Remove unlikely() from ttwu_post_activation

Yong Zhang (1):
      sched: Cleanup pre_schedule_rt

----
 kernel/sched.c    |    4 ++--
 kernel/sched_rt.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
