Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1LLR0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:26:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1LLR0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:26:04 -0500
Date: Mon, 12 Dec 2011 18:24:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Arun Sharma <asharma@fb.com>, David Ahern <dsahern@gmail.com>,
        devel@openvz.org, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20111212172404.GE23870@elte.hu>
References: <1323696369-14688-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323696369-14688-1-git-send-email-acme@infradead.org>
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
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Andrew Vagin (1):
>   perf tools: Add ability to synthesize event according to a sample
> 
> Robert Richter (2):
>   perf script: Fix mem leaks and NULL pointer checks around strdup()s
>   perf script: Implement option for system-wide profiling
> 
>  tools/perf/builtin-script.c |   63 +++++++++++++++++++++-------------
>  tools/perf/util/event.h     |    3 ++
>  tools/perf/util/evsel.c     |   79 +++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/session.h   |    8 ++++
>  4 files changed, 129 insertions(+), 24 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
