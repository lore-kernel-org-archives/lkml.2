Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab1CQTWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:22:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab1CQTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:22:10 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ONZfmUNiLwMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=MtIc4R8h7hGkPJ7lFqIA:9 a=o8kNoMmn6meXVVzSpcuTkhRxdqAA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110317192105.308382309@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 15:21:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 0/2] [GIT PULL] futex: Fix WARN_ON triggering on UP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Please pull the rt patches from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

    branch: tip/futex/devel


Steven Rostedt (2):
      WARN_ON_SMP(): Allow use in if statements on UP
      futex: Fix WARN_ON() test for UP

----
 include/asm-generic/bug.h |   28 +++++++++++++++++++++++++++-
 kernel/futex.c            |    4 ++--
 2 files changed, 29 insertions(+), 3 deletions(-)

