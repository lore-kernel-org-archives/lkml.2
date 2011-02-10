Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1BJQvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:51:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab1BJQvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:51:40 -0500
Date: Thu, 10 Feb 2011 17:51:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, mingo@redhat.com, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
 regression
Message-ID: <20110210165124.GA3699@elte.hu>
References: <new-submission>
 <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
 <1297224378.8035.7.camel@marge.simson.net>
 <20110209164154.GA15607@ghostprotocols.net>
 <1297309313.7996.11.camel@marge.simson.net>
 <20110210121559.GA26094@elte.hu>
 <1297341811.5512.36.camel@marge.simson.net>
 <20110210161537.GA20676@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210161537.GA20676@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Thu, Feb 10, 2011 at 01:43:31PM +0100, Mike Galbraith escreveu:
> > On Thu, 2011-02-10 at 13:15 +0100, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > Initial impression: can I have a pony too? :)
> > > > 
> > > > I like this a lot, great for live rummaging.  One thing that would help with large 
> > > > files maybe - a jump to next spot hotter than N%, but as is is quite nice.
> 
> It already does that if you use TAB/shift-TAB, first one goes to the
> hottest line, next one to the 2nd place, etc, shift-TAB goes the other
> direction.

A minor request: could we also make it an intuitive shift+arrow-keys thing as well 
perhaps? I.e. Shift will 'modify' the meaning of regular navigation of the lines 
from 'next' to 'next highest', etc.

Thanks,

	Ingo
