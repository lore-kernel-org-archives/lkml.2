Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0IWDFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:05:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0IWDFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:05:52 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=_klwrrgwrrkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=6MYuLJYCYU000VrQ_kQA:9 a=pZEDtJwBFQV_km3F8084cAT5V98A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923030359.649647055@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:03:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][v2.6.36] tracing: fixes for tracing virt guests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I actually did these fixes back in July for RHEL, but forgot about
them for mainline :-(

Jeremy hit the same bug and set me a fix. It was only part of what
I did in July, so I pulled in his fix and added the second part.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Jeremy Fitzhardinge (1):
      tracing/x86: Don't use mcount in pvclock.c

Steven Rostedt (1):
      tracing/x86: Don't use mcount in kvmclock.c

----
 arch/x86/kernel/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
