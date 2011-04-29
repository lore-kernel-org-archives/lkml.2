Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab1D2R7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:59:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab1D2R7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:59:19 -0400
Date: Fri, 29 Apr 2011 19:59:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: perf stat branch: perf stat fails on unsupported event
Message-ID: <20110429175911.GA7045@elte.hu>
References: <4DBAC59F.2020009@gmail.com>
 <20110429142037.GB4106@elte.hu>
 <4DBACF9F.1080200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBACF9F.1080200@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* David Ahern <dsahern@gmail.com> wrote:

> On 04/29/11 08:20, Ingo Molnar wrote:
> > 
> > * David Ahern <dsahern@gmail.com> wrote:
> > 
> >> This is a Dell R410 with an E5620 processor.
> > 
> > That's a Westmere CPU.
> > 
> > Could you check whether the patch below applied to latest -tip gives you 
> > stalled-cycles-frontend and stalled-cycles-backend events?
> 
> yes, it does. And I see it's been committed already. ;-)

yeah :-)

Thanks,

	Ingo
