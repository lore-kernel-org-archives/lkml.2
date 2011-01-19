Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1ASHT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 02:19:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1ASHT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 02:19:27 -0500
Date: Wed, 19 Jan 2011 08:19:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        samu.p.onkalo@nokia.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Subject: Re: Bug in scheduler when using rt_mutex
Message-ID: <20110119071917.GA26086@elte.hu>
References: <1295280032.30950.128.camel@laptop>
 <1295339012.11678.35.camel@kolo>
 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
 <1295357746.30950.681.camel@laptop>
 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
 <1295408637.8017.56.camel@marge.simson.net>
 <AANLkTineieNdiKduDHQ-J+Xv6Pq9O0pTZraBJEw=p5e7@mail.gmail.com>
 <1295415657.8017.113.camel@marge.simson.net>
 <AANLkTinfGL3=8LKTx3gCg_V9DfXi44E2PxPd-vQVfALU@mail.gmail.com>
 <1295419041.8017.120.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295419041.8017.120.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2011-01-19 at 14:09 +0800, Yong Zhang wrote:
> > On Wed, Jan 19, 2011 at 1:40 PM, Mike Galbraith <efault@gmx.de> wrote:
> > > On Wed, 2011-01-19 at 12:35 +0800, Yong Zhang wrote:
> > >
> > >> cfs_rq->curr != se is always true.
> > >
> > > If that were always true, we'd illegally enqueue a running task.
> > 
> > I'm sorry that I'm not express myself correctly.
> 
> Human communication methods are all buggy as hell :)

Not to mention that they are slow, inefficient and ambiguous.

But wht did you expect? The original authors of the code are long gone and 
maintenance is done by newcomers who are patching the code bit by bit. What
you get from such a development model is pretty predictable: ~1 billion years
old spaghetti DNA that no-one truly understands.

	Ingo
