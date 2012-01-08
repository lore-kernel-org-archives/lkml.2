Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2AHQCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:02:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42956 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab2AHQCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:02:33 -0500
Date: Sun, 8 Jan 2012 17:02:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/9] perf/core fixes and improvements
Message-ID: <20120108160217.GA5454@elte.hu>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326037339-31125-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling.
> 
> Regards,
> 
> - Arnaldo
> 
> The following changes since commit b9f616bbf4a917398aa09db89efbdf9a204e80dc:
> 
>   Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-01-08 12:36:18 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> for you to fetch changes up to 172d1b0b73256551f100fc00c69e356d047103f5:
> 
>   perf tools: Fix compile error on x86_64 Ubuntu (2012-01-08 13:34:55 -0200)
> 
> ----------------------------------------------------------------
> Namhyung Kim (9):
>       perf script: Add missing closedir() calls
>       perf test: Change type of '-v' option to INCR
>       perf top: Add error message for EMFILE
>       perf kmem: Add missing closedir() calls
>       perf kmem: Fix a memory leak
>       perf annotate: Fix usage string
>       perf annotate: Get rid of field_sep check
>       perf report: Fix --stdio output alignment when --showcpuutilization used
>       perf tools: Fix compile error on x86_64 Ubuntu
> 
>  tools/perf/builtin-annotate.c      |    7 +------
>  tools/perf/builtin-kmem.c          |    3 +++
>  tools/perf/builtin-script.c        |    4 ++++
>  tools/perf/builtin-test.c          |    2 +-
>  tools/perf/builtin-top.c           |    4 ++++
>  tools/perf/util/hist.c             |   34 ++++++++++++++++++----------------
>  tools/perf/util/trace-event-info.c |    1 -
>  7 files changed, 31 insertions(+), 24 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
