Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1BXUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:16:27 -0500
Received: from www.tglx.de ([62.245.132.106]:50782 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab1BXUQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:16:25 -0500
Date: Thu, 24 Feb 2011 21:16:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <20110224201124.138311ba@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com> <1298573197.2428.457.camel@twins> <20110224201124.138311ba@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Alan Cox wrote:

> > Anybody who is interested in the latency of cpu hotplug is deluding
> > himself, also cpu hotplug is _NOT_ a power management feature, so the
> > rest of your justification just disappeared as well.
> 
> Actually CPU hotplug is a power management feature on some devices where
> you need to shutdown one of the cores to enter low power modes.

Right.

> Remember we use it as part of the suspend paths and various processors
> nowdays drop into a suspend to RAM type state on CPU idling.

The suspend path is using it, but the cpu idle one is hardly using the
hotplug muck.

Thanks,

	tglx
