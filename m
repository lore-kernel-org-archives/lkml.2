Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab1LGW0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:26:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36273 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757752Ab1LGW0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:26:23 -0500
Date: Wed, 7 Dec 2011 23:24:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Anton Blanchard <anton@samba.org>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, devel@openvz.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20111207222439.GC18356@elte.hu>
References: <1323272849-15077-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323272849-15077-1-git-send-email-acme@infradead.org>
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
> git://github.com/acmel/linux.git perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Andrew Vagin (1):
>   perf header: Use event_name() to get an event name
> 
> Anton Blanchard (1):
>   perf stat: Failure with "Operation not supported"
> 
>  tools/perf/builtin-stat.c |    3 ++-
>  tools/perf/util/header.c  |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
