Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0ILTOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:14:38 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38752 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752211Ab0ILTOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:14:37 -0400
Date: Sun, 12 Sep 2010 21:14:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100912191429.GA27440@elf.ucw.cz>
References: <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <20100912064612.GA1582@ucw.cz>
 <4C8D13CD.1060802@redhat.com>
 <20100912184843.GB11165@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912184843.GB11165@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-09-12 20:48:43, Ingo Molnar wrote:
> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> >  On 09/12/2010 08:46 AM, Pavel Machek wrote:
> > >  1- Most (least abstract) specific code: a block of bytecode in the form
> > >     of a simplified, executable, kernel-checked x86 machine code block -
> > >     this is also the fastest form. [yes, this is actually possible.]
> > >Well... if we want to be a bit x86-entric.... can we just reuse ACPI
> > >interpretter?
> > 
> > I hope this was a joke, ACPI won the academy awards for ugliness, 
> > ..., bad specification, non-generality, and 

As did i386 instruction set :-).

> It also combines the worst of the two worlds: it's the most specific 
> type of code (almost like assembly), but has a very slow interpreter.
> 
> With 'x86 bytecode' the main (and pretty much only) point is to be able 
> to execute the code as-is, once checked.
> 
> But, as i explained it before, i only consider it a theoretical 
> possibility and i think that abstract code (such as ASCII text C source 
> code) is a better solution.

Compiler in kernel?

I'm not sure I like that one. Yes, ACPI interpreter is slow, but it is
simple, already in kernel, and there are already tools to compile into
it...

While it may be ugly, I believe it is better than either i386
verifier, compiler in the kernel, or yet another interpretter...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
