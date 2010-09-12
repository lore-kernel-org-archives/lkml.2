Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab0ILStX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:49:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab0ILStV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:49:21 -0400
Date: Sun, 12 Sep 2010 20:48:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100912184843.GB11165@elte.hu>
References: <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <20100912064612.GA1582@ucw.cz>
 <4C8D13CD.1060802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8D13CD.1060802@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2817]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

>  On 09/12/2010 08:46 AM, Pavel Machek wrote:
> >  1- Most (least abstract) specific code: a block of bytecode in the form
> >     of a simplified, executable, kernel-checked x86 machine code block -
> >     this is also the fastest form. [yes, this is actually possible.]
> >Well... if we want to be a bit x86-entric.... can we just reuse ACPI
> >interpretter?
> 
> I hope this was a joke, ACPI won the academy awards for ugliness, 
> slowness, low performance, bad specification, non-generality, and 
> probably five other things I forgot.  Stay away from it as much as you 
> can.

It also combines the worst of the two worlds: it's the most specific 
type of code (almost like assembly), but has a very slow interpreter.

With 'x86 bytecode' the main (and pretty much only) point is to be able 
to execute the code as-is, once checked.

But, as i explained it before, i only consider it a theoretical 
possibility and i think that abstract code (such as ASCII text C source 
code) is a better solution.

Thanks,

	Ingo
