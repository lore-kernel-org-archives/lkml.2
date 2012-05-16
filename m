Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712Ab2EPUNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:13:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15282 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760612Ab2EPUNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:13:47 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XlIr_nCh6zIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=uYr987ZBMuE7JBIAYQ8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337199226.6724.84.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 May 2012 16:13:46 -0400
In-Reply-To: <4FB408F2.8060002@linux.intel.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
	 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
	 <1337198404.6724.81.camel@gandalf.stny.rr.com>
	 <CA+55aFyKiNBRv=z8JjPTu=yFFvyWHhkGDxjWLm=R4HpwXzEw4g@mail.gmail.com>
	 <4FB408F2.8060002@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 13:07 -0700, Arjan van de Ven wrote:
> On 5/16/2012 1:04 PM, Linus Torvalds wrote:
> > On Wed, May 16, 2012 at 1:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>
> >> Seriously though. What's your take on changing the kernel that will
> >> break an older distro. Obviously, this change is too early to apply. But
> >> because an old distro has one app that will break if we make a change in
> >> the kernel, is that enough to keep that change out?
> > 
> > I suspect that powertop is enough of a developer thing that if that's
> > the only thing that breaks, we don't have to worry too much.
> > 
> > I don't want to break *everybody*, so new distro's should be
> > up-to-date. But breaking something like a F14-15 timeframe distro or
> > something staid like a SLES (or "Debian Stale" or whatever they call
> > that thing that only takes crazy-old binaries)? It's fine. We don't
> > want to *rush* into it, but no, if those distros are basically not
> > updating, we can't care about them forever for something like
> > powertop.
> 
> agreed.
> 
> I would say something like "6 months" (e.g. 3.6); anybody who's likely
> to update anything will have done the powertop upgrade from his distro
> by then, and anybody who isn't isn't going to update the kernel either.
> 

Thanks for the clarification. I'll put the patch in my 3.6 or 3.7 queue.

-- Steve


