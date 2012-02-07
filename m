Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2BGIrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:47:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab2BGIrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:47:16 -0500
Date: Tue, 7 Feb 2012 09:46:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Clark Williams <williams@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stable@kernel.org,
        arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120207084652.GB15359@elte.hu>
References: <1328564169-26517-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328564169-26517-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> The following changes since commit 84f2b9b2edc09595569c7397cc3c888764ffd78b:
> 
>   perf: Remove deprecated WARN_ON_ONCE() (2012-02-03 08:24:40 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-urgent-for-mingo
> 
> for you to fetch changes up to a4a03fc7ef89020baca4f19174e6a43767c6d78a:
> 
>   perf evsel: Fix an issue where perf report fails to show the proper percentage (2012-02-06 18:59:38 -0200)
> 
> ----------------------------------------------------------------
> Fixes for some long standing problems.
> 
> ----------------------------------------------------------------
> Jiri Olsa (2):
>       perf tools: Fix perf stack to non executable on x86_64
>       perf tools: Fix prefix matching for kernel maps
> 
> Naveen N. Rao (1):
>       perf evsel: Fix an issue where perf report fails to show the proper percentage
> 
>  tools/perf/bench/mem-memcpy-x86-64-asm.S |    6 ++++++
>  tools/perf/util/event.c                  |    2 +-
>  tools/perf/util/evsel.c                  |    1 +
>  3 files changed, 8 insertions(+), 1 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
