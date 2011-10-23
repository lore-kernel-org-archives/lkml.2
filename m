Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1JWLBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:01:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48998 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab1JWLBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:01:07 -0400
Date: Sun, 23 Oct 2011 12:59:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/4] perf/core improvements and fixes
Message-ID: <20111023105928.GA5156@elte.hu>
References: <1319115948-12060-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319115948-12060-1-git-send-email-acme@infradead.org>
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

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf hists browser: Honour symbol_conf.show_{nr_samples,total_period}
>   perf hists: Don't decay total_period for filtered entries
>   perf hists: Don't consider filtered entries when calculating column widths
>   perf hists browser: Elide DSO column when it is set to just one DSO, ditto for threads
> 
>  tools/perf/util/hist.c              |   14 ++++++++++----
>  tools/perf/util/sort.c              |    4 +++-
>  tools/perf/util/ui/browsers/hists.c |   14 ++++++++++++++
>  3 files changed, 27 insertions(+), 5 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
