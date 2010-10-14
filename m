Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0JNVBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:01:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0JNVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:01:37 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=aVexUbfesJsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=-qyj32d2bavSKlCirEUA:9 a=iXoBK5-wkED3Cc23joPiKscFBTYA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101014210014.895157788@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Oct 2010 17:00:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][2.6.37] ftrace: C version of recordmcount
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/recordmcount tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/recordmcount


John Reiser (1):
      ftrace: Add C version of recordmcount compile time code

Steven Rostedt (2):
      ftrace/x86: Add support for C version of recordmcount
      ftrace: Remove duplicate code for 64 and 32 bit in recordmcount.c

----
 Makefile               |    6 +
 arch/x86/Kconfig       |    1 +
 kernel/trace/Kconfig   |    5 +
 scripts/Makefile       |    1 +
 scripts/Makefile.build |    4 +
 scripts/recordmcount.c |  345 +++++++++++++++++++++++++++++++++++++++++++++
 scripts/recordmcount.h |  366 ++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 728 insertions(+), 0 deletions(-)
