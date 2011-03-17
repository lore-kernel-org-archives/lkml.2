Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1CQV6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:58:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab1CQV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:58:30 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=nqIQ-bezW1sA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=MtIc4R8h7hGkPJ7lFqIA:9 a=_2aPwqQw1yRPDtbk9amItOXxCQ0A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110317215612.566569234@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 17:56:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 0/2 v2] [GIT PULL] futex: Fix WARN_ON trigging on UP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Changes for v2:

 o Added Darren's Acked-by to 2/2

 o Two be's or not two be's... THAT is the question!
    (the answer is one be)

Please pull the futex patches from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

    branch: tip/futex/devel


Steven Rostedt (2):
      WARN_ON_SMP(): Allow use in if statements on UP
      futex: Fix WARN_ON() test for UP

----
 include/asm-generic/bug.h |   28 +++++++++++++++++++++++++++-
 kernel/futex.c            |    4 ++--
 2 files changed, 29 insertions(+), 3 deletions(-)

