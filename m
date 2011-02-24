Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab1BXUYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:24:50 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37534 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab1BXUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:24:48 -0500
Date: Thu, 24 Feb 2011 15:24:44 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com> <1298573197.2428.457.camel@twins> <20110224201124.138311ba@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Thomas Gleixner wrote:

> On Thu, 24 Feb 2011, Alan Cox wrote:
> 
> > > Anybody who is interested in the latency of cpu hotplug is deluding
> > > himself, also cpu hotplug is _NOT_ a power management feature, so the
> > > rest of your justification just disappeared as well.
> > 
> > Actually CPU hotplug is a power management feature on some devices where
> > you need to shutdown one of the cores to enter low power modes.
> 
> Right.
> 
> > Remember we use it as part of the suspend paths and various processors
> > nowdays drop into a suspend to RAM type state on CPU idling.
> 
> The suspend path is using it, but the cpu idle one is hardly using the
> hotplug muck.

Most SMP ARM processors are going to use it soon.  Powering down idle 
cores provides substantial power saving.


Nicolas
