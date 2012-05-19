Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab2ESBnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:43:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2ESBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:43:38 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=mtloJUw6WWAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=C4wabflVbsGNTArt7ecA:9 a=Ut3vS4csiTRVBCAwAa4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337391816.7562.18.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/15] [GIT PULL] tracing: Updates for 3.5
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 18 May 2012 21:43:36 -0400
In-Reply-To: <20120518130858.392919640@goodmis.org>
References: <20120518130858.392919640@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 09:08 -0400, Steven Rostedt wrote:
> Ingo,
> 
> This should be my last set of changes for the next merge window.

Not quite :-)

You can hold off on pulling this. I want to add Masami's Acked-by tag,
and Vaibhav gave me two more patches. I'll run it through my own tests
and then do another pull request.

Thanks!

-- Steve

> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: b732d439cb43336cd6d7e804ecb2c81193ef63b0
> 
> 
> Namhyung Kim (1):
>       tracing: Check return value of tracing_dentry_percpu()
> 
> Steven Rostedt (11):
>       tracing: Clean up tracing_mark_write()
>       ring-buffer: Add integrity check at end of iter read
>       ring-buffer: Reset head page before running self test
>       ftrace: Sort all function addresses, not just per page
>       ftrace: Remove extra helper functions
>       ftrace: Speed up search by skipping pages by address
>       ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
>       ftrace: Return record ip addr for ftrace_location()
>       ftrace: Make ftrace_modify_all_code() global for archs to use
>       ftrace/x86: Have x86 ftrace use the ftrace_modify_all_code()
>       ftrace: Remove selecting FRAME_POINTER with FUNCTION_TRACER
> 
> Vaibhav Nagarnaik (3):
>       ring-buffer: Make removal of ring buffer pages atomic
>       ring-buffer: Make addition of pages in ring buffer atomic
>       tracing: change CPU ring buffer state from tracing_cpumask
> 
> ----
>  arch/x86/kernel/ftrace.c          |   15 +-
>  include/asm-generic/vmlinux.lds.h |    2 +-
>  include/linux/ftrace.h            |    5 +-
>  kernel/trace/Kconfig              |    1 -
>  kernel/trace/ftrace.c             |  198 ++++++++++---------
>  kernel/trace/ring_buffer.c        |  394 +++++++++++++++++++++++++++++--------
>  kernel/trace/trace.c              |   49 ++---
>  7 files changed, 446 insertions(+), 218 deletions(-)


