Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0ILWTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 18:19:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0ILWTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 18:19:30 -0400
Date: Mon, 13 Sep 2010 00:19:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100912221906.GA22029@elte.hu>
References: <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <20100912064612.GA1582@ucw.cz>
 <4C8D13CD.1060802@redhat.com>
 <20100912184843.GB11165@elte.hu>
 <20100912191429.GA27440@elf.ucw.cz>
 <20100912203258.GC16751@elte.hu>
 <20100912210607.GE27440@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912210607.GE27440@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2604]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> On Sun 2010-09-12 22:32:58, Ingo Molnar wrote:
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > > On Sun 2010-09-12 20:48:43, Ingo Molnar wrote:
> 
> > > > > >  1- Most (least abstract) specific code: a block of bytecode in the form
> > > > > >     of a simplified, executable, kernel-checked x86 machine code block -
> > > > > >     this is also the fastest form. [yes, this is actually possible.]
> > > > > >Well... if we want to be a bit x86-entric.... can we just reuse ACPI
> > > > > >interpretter?
> > > > > 
> > > > > I hope this was a joke, ACPI won the academy awards for ugliness, 
> > > > > ..., bad specification, non-generality, and 
> > > 
> > > As did i386 instruction set :-).
> > 
> > Are you kidding? The i386 instruction set may be ugly, but it's 
> > implemented in hardware, which has obvious upsides.
> 
> I was partly joking. But you have to admit that i386 set is ugly and 
> badly specified.

Fortunately since i already said that it's ugly, in the sentence you 
quote above, i dont have to 'admit' it yet again, right? ;-)

Thanks,

	Ingo
