Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab2LHOza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:55:30 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50185 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2LHOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:55:28 -0500
Date: Sat, 8 Dec 2012 15:55:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL][3.8] tracing: Updated patches
Message-ID: <20121208145523.GH12011@gmail.com>
References: <20121114185333.818952665@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114185333.818952665@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This includes the updates to the formating issues to the patches
> that were in the original patch set, and which I had dropped from
> my last pull request. I added this on top of my last git pull request.
> 
> I also included Shan's dead comment removal.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 1c7d66732458dc187008e3f5b2f71e019e320fc2
> 
> 
> David Sharp (2):
>       tracing,x86: Add a TSC trace_clock
>       tracing: Format non-nanosec times from tsc clock without a decimal point.
> 
> Shan Wei (1):
>       tracing: Kill unused and puzzled sample code in ftrace.h
> 
> Yoshihiro YUNOMAE (1):
>       tracing: Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock
> 
> ----
>  arch/alpha/include/asm/Kbuild      |    1 +
>  arch/arm/include/asm/Kbuild        |    1 +
>  arch/arm64/include/asm/Kbuild      |    1 +
>  arch/avr32/include/asm/Kbuild      |    1 +
>  arch/blackfin/include/asm/Kbuild   |    1 +
>  arch/c6x/include/asm/Kbuild        |    1 +
>  arch/cris/include/asm/Kbuild       |    1 +
>  arch/frv/include/asm/Kbuild        |    1 +
>  arch/h8300/include/asm/Kbuild      |    1 +
>  arch/hexagon/include/asm/Kbuild    |    1 +
>  arch/ia64/include/asm/Kbuild       |    1 +
>  arch/m32r/include/asm/Kbuild       |    1 +
>  arch/m68k/include/asm/Kbuild       |    1 +
>  arch/microblaze/include/asm/Kbuild |    1 +
>  arch/mips/include/asm/Kbuild       |    1 +
>  arch/mn10300/include/asm/Kbuild    |    1 +
>  arch/openrisc/include/asm/Kbuild   |    1 +
>  arch/parisc/include/asm/Kbuild     |    1 +
>  arch/powerpc/include/asm/Kbuild    |    1 +
>  arch/s390/include/asm/Kbuild       |    1 +
>  arch/score/include/asm/Kbuild      |    1 +
>  arch/sh/include/asm/Kbuild         |    1 +
>  arch/sparc/include/asm/Kbuild      |    1 +
>  arch/tile/include/asm/Kbuild       |    1 +
>  arch/um/include/asm/Kbuild         |    1 +
>  arch/unicore32/include/asm/Kbuild  |    1 +
>  arch/x86/include/asm/trace_clock.h |   20 +++++++++
>  arch/x86/kernel/Makefile           |    1 +
>  arch/x86/kernel/trace_clock.c      |   21 ++++++++++
>  arch/xtensa/include/asm/Kbuild     |    1 +
>  include/asm-generic/trace_clock.h  |   16 ++++++++
>  include/linux/ftrace_event.h       |    6 +++
>  include/linux/trace_clock.h        |    2 +
>  include/trace/ftrace.h             |   73 ---------------------------------
>  kernel/trace/trace.c               |   39 +++++++++++++-----
>  kernel/trace/trace.h               |    4 --
>  kernel/trace/trace_output.c        |   78 ++++++++++++++++++++++++------------
>  37 files changed, 176 insertions(+), 111 deletions(-)

Pulled, thanks Steve!

	Ingo
