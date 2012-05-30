Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2E3HA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:00:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52765 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2E3HA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:00:27 -0400
Date: Wed, 30 May 2012 09:00:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20120530070018.GA2587@gmail.com>
References: <1338336688-25616-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338336688-25616-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling.
> 
> 	There are 5 other fixes in this repo, that went on my previous
> perf/urgent pull request.
> 
> Thanks,
> 
> - Arnaldo
> 
> 
> The following changes since commit a00dc319e98161949aa87f71a17db32e925c3257:
> 
>   perf record: Fix branch_stack type in perf_record_opts (2012-05-25 18:32:44 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to a44b45f236dd1c1a8caccf9a078adf2941a20267:
> 
>   perf annotate browser: The idx_asm field should be used in asm only view (2012-05-29 20:52:38 -0300)
> 
> ----------------------------------------------------------------
> Fixes for perf/urgent
> 
> . Fix fallback to --stdio when TUI not supported, from Namhyung Kim.
> 
> . Use right cast for pointers/long in libtraceevent, from Namhyung Kim.
> 
> . Be consistent on using the right error reporting interface for fatal errors,
>   from Namhyung Kim.
> 
> . Fix fallback to --stdio when TUI not supported, from Namhyung Kim.
> 
> . Use the right index in asm only view in the annotate browser.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf annotate browser: The idx_asm field should be used in asm only view
> 
> Namhyung Kim (3):
>       tools lib traceevent: Silence compiler warning on 32bit build
>       perf ui: Make --stdio default when TUI is not supported
>       perf tools: Convert critical messages to ui__error()
> 
>  tools/lib/traceevent/parse-filter.c |    2 +-
>  tools/perf/builtin-annotate.c       |    2 +-
>  tools/perf/builtin-record.c         |   14 +++++++-------
>  tools/perf/builtin-report.c         |   14 ++++++--------
>  tools/perf/builtin-top.c            |   22 +++++++++++-----------
>  tools/perf/ui/browsers/annotate.c   |    6 +++++-
>  tools/perf/ui/setup.c               |    1 +
>  7 files changed, 32 insertions(+), 29 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
