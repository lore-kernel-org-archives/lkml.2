Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0DDXVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 19:21:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:45488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0DDXU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 19:20:56 -0400
Date: Sun, 4 Apr 2010 20:20:42 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/2] perf newt: Zoom operations
Message-ID: <20100404232042.GB3908@ghostprotocols.net>
References: <1270345250-4833-1-git-send-email-acme@infradead.org>
 <20100404095827.GA30536@elte.hu>
 <20100404125354.GA3908@ghostprotocols.net>
 <20100404190512.GB4564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404190512.GB4564@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Apr 04, 2010 at 09:05:12PM +0200, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > Em Sun, Apr 04, 2010 at 11:58:27AM +0200, Ingo Molnar escreveu:
> > > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > > Arnaldo Carvalho de Melo (2):
> > > >   perf newt: Add a "Zoom into foo.so DSO" and reverse operations
> > > >   perf TUI: Add a "Zoom into COMM(PID) thread" and reverse operations
> > > 
> > > Pulled, thanks Arnaldo!
> > > 
> > > There's still a few basic usability glitches that i've noticed:
> > > 
> > >  - it's not clear how to zoom out, once zoomed in
> > 
> > I'll use the title line to store the name of the DSO and Thread and the help 
> > line to state that to zoom out, press -> + zoom out, and I think that it is 
> > a good idea to use 'd' and 'D' to zoom in/out of DSOs and 't' and 'T' to 
> > zoom in/out of DSOs.
> 
> Cool, a help line will do the trick i'm sure. The only problem situation is 
> when there is zero information about how to proceed - some people exit and 
> dont ever come back in that case :-)

Yeah, first impression is always important to take into account, but
difficult to get it right, what I'm trying, as much as possible, is to
keep key assignments as intuitive as possible, but early adopters are
key in this regard, so please do speak up!
 
> > >  - there's no help screen and no help line for people to see what can be 
> > >    done on a given screen. While it's good that the intuitive things work
> > >    by default (arrow keys, escape, enter, etc.), there should also be additional
> > >    visual information about what can be done.
> > 
> > F1 and textboxes with a short description of what can be done given for the 
> > first time or till the user presses "Suppress these info boxes" will be 
> > added.
> 
> Maybe we need 'h' and '?' in addition of F1, as F1 is often already mapped and 
> caught by the terminal (it is so with gnome-terminal).

Right, h and ? will be mapped too, even I'm not being aware that those
are associated with asking for help, but the
ask-for-help-via-F1-taken-by-your-xterm-app problem is well known and we
have to provide a workaround for that :-)
 
> >  
> > >  - i think double escape should exit, right now it stays at the 'are you sure'
> > >    screen
> > 
> > Here I thought that something had to be done to avoid that accidentally 
> > pressing ESC two times or having "Yes" as default option, trowing away 
> > possibly a long processed session, what do others think about it?
> 
> Yeah, i think you are right.
> 
> > I think that ESC + "Yes" as a default may be ok, as two keys need to be 
> > pressed (ESC + Enter), enough warning/confirmation, I gues, right?
> 
> Ok, that would work!

Excellent, I almost got the title line for in place filters bullet done
before being dragged by family to go out fishing, will fishing, oops,
finish that tomorrow :-)

- Arnaldo
