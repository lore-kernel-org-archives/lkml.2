Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0DDTF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 15:05:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59861 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0DDTFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 15:05:22 -0400
Date: Sun, 4 Apr 2010 21:05:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/2] perf newt: Zoom operations
Message-ID: <20100404190512.GB4564@elte.hu>
References: <1270345250-4833-1-git-send-email-acme@infradead.org>
 <20100404095827.GA30536@elte.hu>
 <20100404125354.GA3908@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404125354.GA3908@ghostprotocols.net>
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

> Em Sun, Apr 04, 2010 at 11:58:27AM +0200, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > Arnaldo Carvalho de Melo (2):
> > >   perf newt: Add a "Zoom into foo.so DSO" and reverse operations
> > >   perf TUI: Add a "Zoom into COMM(PID) thread" and reverse operations
> > 
> > Pulled, thanks Arnaldo!
> > 
> > There's still a few basic usability glitches that i've noticed:
> > 
> >  - it's not clear how to zoom out, once zoomed in
> 
> I'll use the title line to store the name of the DSO and Thread and the help 
> line to state that to zoom out, press -> + zoom out, and I think that it is 
> a good idea to use 'd' and 'D' to zoom in/out of DSOs and 't' and 'T' to 
> zoom in/out of DSOs.

Cool, a help line will do the trick i'm sure. The only problem situation is 
when there is zero information about how to proceed - some people exit and 
dont ever come back in that case :-)

> >  - there's no help screen and no help line for people to see what can be 
> >    done on a given screen. While it's good that the intuitive things work
> >    by default (arrow keys, escape, enter, etc.), there should also be additional
> >    visual information about what can be done.
> 
> F1 and textboxes with a short description of what can be done given for the 
> first time or till the user presses "Suppress these info boxes" will be 
> added.

Maybe we need 'h' and '?' in addition of F1, as F1 is often already mapped and 
caught by the terminal (it is so with gnome-terminal).

>  
> >  - i think double escape should exit, right now it stays at the 'are you sure'
> >    screen
> 
> Here I thought that something had to be done to avoid that accidentally 
> pressing ESC two times or having "Yes" as default option, trowing away 
> possibly a long processed session, what do others think about it?

Yeah, i think you are right.

> I think that ESC + "Yes" as a default may be ok, as two keys need to be 
> pressed (ESC + Enter), enough warning/confirmation, I gues, right?

Ok, that would work!

Thanks,

	Ingo
