Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2KZNsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:48:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2KZNr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:47:59 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_qPozqkUF18A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=b9CD_O2X3ukA:10 a=VwQbUJbxAAAA:8 a=4Ko6lpb34adjaTE3TiUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353937677.6276.28.camel@gandalf.local.home>
Subject: Re: [PATCH 0/4] [GIT PULL][3.8] tracing: Updated patches
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 Nov 2012 08:47:57 -0500
In-Reply-To: <20121114185333.818952665@goodmis.org>
References: <20121114185333.818952665@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

-- Steve


On Wed, 2012-11-14 at 13:53 -0500, Steven Rostedt wrote:
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


