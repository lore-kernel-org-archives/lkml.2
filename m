Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab2JZOy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:54:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54754 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2JZOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:54:56 -0400
Date: Fri, 26 Oct 2012 16:54:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121026145451.GA14379@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351261913-28250-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 8f7c1d07ade50dcdea7ec779b277e891f5c8292a:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-10-26 10:30:49 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 1f16c5754d3a4008c29f3bf67b4f1271313ba385:
> 
>   perf stat: Add --pre and --post command (2012-10-26 11:22:25 -0200)
> 
> ----------------------------------------------------------------
> perf/core improvements:
> 
> . perf inject changes to allow showing where a task sleeps, from Andrew Vagin.
> 
> . Makefile improvements from Namhyung Kim.

These are really useful: there used to be a couple of seconds of 
wait time at the beginning of every perf build - these are now 
nicely explained with the various CHK entries.

> 
> . Add --pre and --post command hooks in 'stat', from Peter Zijlstra.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Andrew Vagin (3):
>       perf inject: Work with files
>       perf inject: Merge sched_stat_* and sched_switch events
>       perf inject: Mark a dso if it's used
> 
> Namhyung Kim (5):
>       tools lib traceevent: Do not generate dependency for system header files
>       perf tools: Cleanup doc related targets
>       perf tools: Convert invocation of MAKE into SUBDIR
>       perf tools: Always show CHK message when doing try-cc
>       perf tools: Fix LIBELF_MMAP checking
> 
> Peter Zijlstra (1):
>       perf stat: Add --pre and --post command
> 
>  tools/lib/traceevent/Makefile            |    2 +-
>  tools/perf/Documentation/perf-inject.txt |   11 ++
>  tools/perf/Documentation/perf-stat.txt   |    5 +
>  tools/perf/Makefile                      |   51 ++------
>  tools/perf/builtin-inject.c              |  189 ++++++++++++++++++++++++++++--
>  tools/perf/builtin-stat.c                |   42 ++++++-
>  tools/perf/config/utilities.mak          |    3 +-
>  tools/perf/util/build-id.c               |   10 +-
>  tools/perf/util/build-id.h               |    4 +
>  9 files changed, 256 insertions(+), 61 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
