Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0KLPM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:12:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab0KLPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:12:24 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=NWlxo2SncNoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Cj8vSp6T_1oWnt8ar9YA:9 a=IzoGefwXm-_w6h1DgId80rVzBNwA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101112151045.672405637@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Nov 2010 10:10:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][2.6.37] tracing: fixes v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

My last pull request, I had [PATCH] instead of [GIT PULL].
You may ignore it as this pull request includes those two patches.

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-2


Steven Rostedt (3):
      tracing: Fix module use of trace_bprintk()
      tracing: Force arch_local_irq_* notrace for paravirt
      tracing: Fix recursive user stack trace

----
 arch/x86/include/asm/paravirt.h |   10 +++++-----
 kernel/module.c                 |   12 ++++++++++++
 kernel/trace/trace.c            |   19 +++++++++++++++++++
 3 files changed, 36 insertions(+), 5 deletions(-)
