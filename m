Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354Ab2CNRv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:51:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55906 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761154Ab2CNRvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:51:23 -0400
Date: Wed, 14 Mar 2012 18:50:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Ahern <dsahern@gmail.com>, Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@kernel.org,
        Stephane Eranian <eranian@google.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120314175056.GA27456@elte.hu>
References: <1331744322-18917-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331744322-18917-1-git-send-email-acme@infradead.org>
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
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 8aa8a7c80ccdfac2df5ee48a51a4a7bee2143d4f:
> 
>   perf record: Fix buffer overrun bug in tracepoint_id_to_path() (2012-03-13 17:01:28 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to eae7a755ee81129370c8f555b0d5672e6673735d:
> 
>   perf tools, x86: Build perf on older user-space as well (2012-03-14 12:42:34 -0300)
> 
> ----------------------------------------------------------------
> Some corner cases fixes.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Anton Blanchard (1):
>       perf tools: Incorrect use of snprintf results in SEGV
> 
> Arnaldo Carvalho de Melo (1):
>       perf tools: Use scnprintf where applicable
> 
> Ingo Molnar (1):
>       perf tools, x86: Build perf on older user-space as well
> 
>  tools/perf/Makefile                     |    2 ++
>  tools/perf/arch/powerpc/util/header.c   |    2 +-
>  tools/perf/arch/x86/util/header.c       |    2 +-
>  tools/perf/perf.h                       |    6 ++++++
>  tools/perf/util/color.c                 |    9 +++++----
>  tools/perf/util/header.c                |    4 ++--
>  tools/perf/util/hist.c                  |   30 +++++++++++++++---------------
>  tools/perf/util/include/asm/unistd_32.h |    1 +
>  tools/perf/util/include/asm/unistd_64.h |    1 +
>  tools/perf/util/sort.c                  |    3 +++
>  tools/perf/util/strbuf.c                |    7 ++++---
>  tools/perf/util/ui/browsers/hists.c     |   12 ++++++------
>  tools/perf/util/ui/helpline.c           |    2 +-
>  13 files changed, 48 insertions(+), 33 deletions(-)
>  create mode 100644 tools/perf/util/include/asm/unistd_32.h
>  create mode 100644 tools/perf/util/include/asm/unistd_64.h

Pulled, thanks Arnaldo!

	Ingo
