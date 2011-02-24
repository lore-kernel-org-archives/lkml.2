Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1BXVdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:33:49 -0500
Received: from www.tglx.de ([62.245.132.106]:60515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1BXVdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:33:47 -0500
Date: Thu, 24 Feb 2011 22:33:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <1298582255.5226.843.camel@laptop>
Message-ID: <alpine.LFD.2.00.1102242231530.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>  <1298573197.2428.457.camel@twins>  <20110224201124.138311ba@lxorguk.ukuu.org.uk>  <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>  <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
  <1298579452.5226.834.camel@laptop>  <alpine.LFD.2.00.1102241536120.31831@xanadu.home>  <alpine.LFD.2.00.1102242148400.2701@localhost6.localdomain6>  <20110224210431.7a6bba68@lxorguk.ukuu.org.uk>  <alpine.LFD.2.00.1102242206560.2701@localhost6.localdomain6>
 <1298582255.5226.843.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Peter Zijlstra wrote:

> On Thu, 2011-02-24 at 22:12 +0100, Thomas Gleixner wrote:
> 
> > If you take down the whole SoC, then it's full S2RAM or some
> > equivilant thing. That's a different story and propably requires the
> > whole hotplug muck.
> 
> Didn't we, during the whole wakelock trainwreck, that s2ram could be
> done from idle as well (for hardware where the whole opportunistic
> suspend was sensible to begin with)?

Yes, needs some more changes to the whole infrastructure of clocks and
power gates, but it's doable.

Thanks,

	tglx
