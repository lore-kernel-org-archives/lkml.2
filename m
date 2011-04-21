Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1DUBnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:43:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38817 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1DUBnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:43:02 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=y2pZLIEcZbAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=eIPyM37EBZSgUZX8jzcA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421014153.126662477@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 21:41:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL] lockdep: Show description of lockdep problems
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/lockdep/devel tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/lockdep/devel


Steven Rostedt (7):
      lockdep: Print a nice description of an irq locking issue
      lockdep: Print a nice description of normal deadlocks
      lockdep: Print a nice description of simple deadlock
      lockdep: Printk nice description for irq inversion bug
      lockdep: Replace bad path error message with something sane
      lockdep: Print a nice description of simple irq inversion
      lockdep: Remove cmpxchg to update nr_chain_hlocks

----
 kernel/lockdep.c |  206 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 195 insertions(+), 11 deletions(-)
