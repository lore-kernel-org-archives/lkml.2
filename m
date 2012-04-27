Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab2D0BqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 21:46:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab2D0BqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 21:46:15 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=1X7j-zY8138A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=9w63ueyTJhxQJwMxuGEA:9 a=OLN5pBgYiS4kSg2211sA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335491171.28106.190.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL] tracing: updates for 3.5
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 26 Apr 2012 21:46:11 -0400
In-Reply-To: <20120426173404.666092637@goodmis.org>
References: <20120426173404.666092637@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I see you pulled in the patches individually instead of doing a git
pull. But you missed the three patches that were in the previous pull
request (that I only left out to not spam LKML as they were not
changed). Also, without the git pull, it makes my repo out of sync with
tip. As that is usually how I know what was pushed upstream or not.

-- Steve


On Thu, 2012-04-26 at 13:34 -0400, Steven Rostedt wrote:
> Ingo,
> 
> Although only two patches are in this, it really contains the 5 patches
> that I pushed out earlier. As only patch 4/5 changed, instead of
> spamming LKML with the same patches 1-3, I'm only reposting 4 and 5.
> 
> Patch 5 just came along for the ride (same as the previous post).
> 
> Patch 4 (here it's patch 1) was update as per Masami's suggestions (again).
> 
> Thanks!
> 
> -- Steve
> 
> Please pull the latest tip/perf/core-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core-2
> 
> Head SHA1: e2017387836dcb963fcbefa767f9f20282349c75
> 
> 
> Steven Rostedt (2):
>       ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine
>       ftrace/x86: Remove the complex ftrace NMI handling code
> 
> ----
>  arch/x86/Kconfig              |    1 -
>  arch/x86/include/asm/ftrace.h |    3 +
>  arch/x86/kernel/ftrace.c      |  511 +++++++++++++++++++++++++++--------------
>  arch/x86/kernel/nmi.c         |   10 +-
>  arch/x86/kernel/traps.c       |    8 +-
>  include/linux/ftrace.h        |    6 +
>  6 files changed, 364 insertions(+), 175 deletions(-)


