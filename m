Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2I1Hzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:55:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57234 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2I1Hzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:55:31 -0400
Date: Fri, 28 Sep 2012 09:50:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/core improvements and fixes
Message-ID: <20120928075008.GB21400@gmail.com>
References: <1348780686-16108-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348780686-16108-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acmeinfradead.org>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 9ec60972a38011ad8a5676f4cd5e51ac508c36b6:
> 
>   perf hists: Add missing period_* fields when collapsing a hist entry (2012-09-26 20:44:11 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to aec1930b0f6f281a0ca038cd03aceace3fe0bb61:
> 
>   perf trace: Add aliases for some syscalls (2012-09-27 13:18:49 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . Improve listing of accessible enum perf probe variables, from Hyeoncheol Lee.
> 
> . Don't stop the build if the audit libraries are not installed, fix from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf trace: Add aliases for some syscalls
> 
> Hyeoncheol Lee (1):
>       perf probe: Print an enum type variable in "enum variable-name" format when showing accessible variables
> 
> Namhyung Kim (1):
>       perf tools: Check libaudit availability for perf-trace builtin
> 
>  tools/perf/Makefile                 |   16 ++++++++++++++--
>  tools/perf/builtin-trace.c          |   26 ++++++++++++++++++--------
>  tools/perf/config/feature-tests.mak |   11 +++++++++++
>  tools/perf/perf.c                   |    2 ++
>  tools/perf/util/dwarf-aux.c         |    2 ++
>  5 files changed, 47 insertions(+), 10 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
