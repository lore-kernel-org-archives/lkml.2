Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab1BXVQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:16:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:56019 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1BXVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:16:11 -0500
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1102242206560.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
	 <1298573197.2428.457.camel@twins>
	 <20110224201124.138311ba@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
	 <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
	 <1298579452.5226.834.camel@laptop>
	 <alpine.LFD.2.00.1102241536120.31831@xanadu.home>
	 <alpine.LFD.2.00.1102242148400.2701@localhost6.localdomain6>
	 <20110224210431.7a6bba68@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1102242206560.2701@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 22:17:35 +0100
Message-ID: <1298582255.5226.843.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 22:12 +0100, Thomas Gleixner wrote:

> If you take down the whole SoC, then it's full S2RAM or some
> equivilant thing. That's a different story and propably requires the
> whole hotplug muck.

Didn't we, during the whole wakelock trainwreck, that s2ram could be
done from idle as well (for hardware where the whole opportunistic
suspend was sensible to begin with)?



