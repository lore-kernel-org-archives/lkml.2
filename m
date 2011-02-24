Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab1BXU3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:29:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab1BXU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:29:32 -0500
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
	 <1298573197.2428.457.camel@twins>
	 <20110224201124.138311ba@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
	 <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 21:30:52 +0100
Message-ID: <1298579452.5226.834.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 15:24 -0500, Nicolas Pitre wrote:

> Most SMP ARM processors are going to use it soon.  Powering down idle 
> cores provides substantial power saving.

And why can't regular idle paths be used? CPU hotplug is a massively
expensive operation.

