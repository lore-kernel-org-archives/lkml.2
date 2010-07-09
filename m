Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0GIDEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:04:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:35427 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0GIDEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:04:35 -0400
Date: Thu, 8 Jul 2010 20:08:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Norbert Preining <preining@logic.at>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100708200821.35173ef8@infradead.org>
In-Reply-To: <1278621854.1900.188.camel@laptop>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	<1278579992.1900.17.camel@laptop>
	<20100708045711.398d4e26@infradead.org>
	<1278590303.1900.91.camel@laptop>
	<20100708120421.GF20841@gamma.logic.tuwien.ac.at>
	<1278591779.1900.97.camel@laptop>
	<20100708124627.GA7754@gamma.logic.tuwien.ac.at>
	<1278595426.1900.130.camel@laptop>
	<1278604779.1900.157.camel@laptop>
	<1278618040.7498.21.camel@marge.simson.net>
	<1278621854.1900.188.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010 22:44:14 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-07-08 at 21:40 +0200, Mike Galbraith wrote:
> > > Mike could you re-run your netperf tests that showed the 10%
> > > throughput gain? Hopefully the fixed governor will yield the same
> > > result and we can kill off this ratelimit thing.
> > 
> > The gain is (well was last time I checked), but as noted, I'd just
> > call it a misguided optimization and be done with it. 
> 
> It would still be good to know what your machine does, if you can
> still see a difference there might still be something to look at.
> 

yeah and if you give me a reason / workload to improve the idle
governor even more.....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
