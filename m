Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2DEQZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:25:05 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:8091 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722Ab2DEQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:25:01 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LLG-01-4HP-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/4] perf: Kernel updates
Date: Thu, 5 Apr 2012 18:24:40 +0200
Message-ID: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclosed some changes made while working with the code. Mostly trivial
but worth to add.

-Robert


Robert Richter (4):
  perf: Trivial cleanup of duplicate code
  perf, x86: Fix cmpxchg() usage in amd_put_event_constraints()
  perf: use static variant of perf_event_overflow in core.c
  perf: Remove PERF_COUNTERS config option

 arch/arm/configs/bcmring_defconfig        |    2 +-
 arch/powerpc/configs/chroma_defconfig     |    2 +-
 arch/powerpc/configs/gamecube_defconfig   |    2 +-
 arch/powerpc/configs/wii_defconfig        |    2 +-
 arch/sh/configs/sh7785lcr_32bit_defconfig |    2 +-
 arch/sparc/configs/sparc64_defconfig      |    2 +-
 arch/x86/kernel/cpu/perf_event.c          |    3 ---
 arch/x86/kernel/cpu/perf_event_amd.c      |    4 +---
 init/Kconfig                              |   14 +-------------
 kernel/events/core.c                      |    2 +-
 10 files changed, 9 insertions(+), 26 deletions(-)

-- 
1.7.8.4


