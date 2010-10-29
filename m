Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab0J2CIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 22:08:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab0J2CHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 22:07:55 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=7lP_iKngrZkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=jOO7u0OJ1EddcHWKlwwA:9 a=y1PGnjB3WI68hF5k9Uo39weOVBoA:4 a=PUjeQqilurYA:10 a=jbrJJM5MRmoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] [GIT PULL] ftrace: recordmcount.c updates for MIPS
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101028140512.441043850@goodmis.org>
References: <20101028140512.441043850@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 22:07:51 -0400
Message-ID: <1288318071.18238.393.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf,

Ingo and I were discussing this patch series, and since it is very
specific to MIPS, we agreed that it makes more sense going through your
tree. it's based off of mainline's commit of:

commit e3e1288e86a07cdeb0aee5860a2dff111c6eff79
Merge: 9ae6d03 964dc25
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Oct 27 19:04:36 2010 -0700

Would you mind pulling from my tree?

Thanks!

-- Steve


On Thu, 2010-10-28 at 10:05 -0400, Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/mips tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/mips
> 
> 
> John Reiser (1):
>       ftrace/MIPS: Add MIPS64 support for C version of recordmcount
> 
> Wu Zhangjin (2):
>       ftrace/MIPS: Add module support for C version of recordmcount
>       ftrace/MIPS: Enable C Version of recordmcount
> 
> ----
>  arch/mips/Kconfig      |    1 +
>  scripts/recordmcount.c |   44 ++++++++++++++++++++++++
>  scripts/recordmcount.h |   86 +++++++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 126 insertions(+), 5 deletions(-)


