Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0EHIC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:02:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0EHICz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:02:55 -0400
Date: Sat, 8 May 2010 10:02:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 0/1] perf list documentation changes
Message-ID: <20100508080225.GD2825@elte.hu>
References: <1273257628-15215-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273257628-15215-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Regards,
> 
> Arnaldo Carvalho de Melo (1):
>   perf list: Improve the raw hw event descriptor documentation
> 
>  tools/perf/Documentation/perf-list.txt |   19 ++++++++++++++++---
>  tools/perf/util/parse-events.c         |    3 ++-
>  2 files changed, 18 insertions(+), 4 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
