Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0GITJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:09:13 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751957Ab0GITJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:09:12 -0400
Date: Fri, 9 Jul 2010 21:09:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       Arjan Van De Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm <akpm@linux-foundation.org>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100709190902.GC1669@ucw.cz>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
 <1278579992.1900.17.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278579992.1900.17.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-07-08 11:06:32, Peter Zijlstra wrote:
> On Wed, 2010-07-07 at 01:45 +0900, Norbert Preining wrote:
> 
> > it seems that some of the (?)recent(?) changes have increased the
> > power consumption of my note book considerably.
> > 
> > First of all, running powertop with normal programs started, but 
> > doing nothing, I am still at 14W while I could go down to 9W before
> > (but the 9W was with dimmed display).
> > 
> > In the list of top causes for wakeup I have
> > Top causes for wakeups:
> >   34.2% (185.3)   [kernel scheduler] Load balancing tick
> >   23.9% (129.6)   [extra timer interrupt]
> >   10.8% ( 58.6)   firefox-bin
> >    9.2% ( 49.7)   [iwlagn] <interrupt>
> >    7.2% ( 39.1)   [kernel core] hrtimer_start (tick_sched_timer)
> >    3.9% ( 20.9)   PS/2 keyboard/mouse/touchpad interrupt
> > which show one new thing to me I haven't seen before, the Loa balancing tick.
>

14W vs 9W is very significant -- is some DMA keeping system from
entering C3? rmmod usb?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
