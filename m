Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1CQQm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:42:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1CQQmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:42:25 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=YyZjyzKDLagA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=pnrHqt6JrD814hP00-MA:9 a=UrJ6aDChuKYS0YzSNOyyzip0vS4A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110317164148.550876008@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 12:41:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL] jump label: Cleanups for 2.6.39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Jan Glauber (1):
      jump label: Add s390 support

Jason Baron (3):
      jump label: Introduce static_branch() interface
      dynamic debug: Add jump label support
      jump label: Add _ASM_ALIGN for x86 and x86_64

----
 arch/mips/include/asm/jump_label.h  |   22 +-
 arch/s390/Kconfig                   |    1 +
 arch/s390/include/asm/jump_label.h  |   37 +++
 arch/s390/kernel/Makefile           |    2 +-
 arch/s390/kernel/jump_label.c       |   59 ++++
 arch/sparc/include/asm/jump_label.h |   25 +-
 arch/x86/include/asm/alternative.h  |    3 +-
 arch/x86/include/asm/jump_label.h   |   27 +-
 arch/x86/kernel/alternative.c       |    2 +-
 arch/x86/kernel/module.c            |    1 +
 include/asm-generic/vmlinux.lds.h   |   14 +-
 include/linux/dynamic_debug.h       |   44 +++-
 include/linux/jump_label.h          |   89 ++++---
 include/linux/jump_label_ref.h      |   44 ---
 include/linux/perf_event.h          |   26 +-
 include/linux/tracepoint.h          |   22 +-
 kernel/jump_label.c                 |  539 ++++++++++++++---------------------
 kernel/perf_event.c                 |    4 +-
 kernel/tracepoint.c                 |   23 +-
 lib/dynamic_debug.c                 |    4 +-
 20 files changed, 494 insertions(+), 494 deletions(-)
