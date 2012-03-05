Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2CEQCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:02:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42722 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2CEQC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:02:27 -0500
Date: Mon, 5 Mar 2012 17:02:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/7] perf/core improvements and fixes
Message-ID: <20120305160209.GA28074@elte.hu>
References: <1330962932-1796-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330962932-1796-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 737f24bda723fdf89ecaacb99fa2bf5683c32799:
> 
>   Merge branch 'perf/urgent' into perf/core (2012-03-05 09:20:08 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to ff2a6617c2acd6a8dc468c90ab8708a6ad112bb0:
> 
>   perf annotate: Add missing newline on error message (2012-03-05 10:15:50 -0300)
> 
> ----------------------------------------------------------------
> Improvements for 'perf annotate' from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Namhyung Kim (7):
>       perf evlist: Restore original errno after open failed
>       perf tools: Add descriptions of missing Makefile arguments
>       perf annotate: Print asm code as blue when source code is displayed
>       perf annotate: Handle lower case key code in annotate_browser__run()
>       perf annotate: Restore title when came back to original symbol
>       perf annotate: Fix help string on tui
>       perf annotate: Add missing newline on error message
> 
>  tools/perf/Makefile                    |   14 ++++++++++++++
>  tools/perf/util/annotate.c             |    2 +-
>  tools/perf/util/evlist.c               |    1 +
>  tools/perf/util/ui/browsers/annotate.c |   18 ++++++++++++------
>  4 files changed, 28 insertions(+), 7 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
