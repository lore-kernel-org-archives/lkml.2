Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1BXUk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:40:26 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35549 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab1BXUkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:40:24 -0500
Date: Thu, 24 Feb 2011 15:40:20 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <1298579452.5226.834.camel@laptop>
Message-ID: <alpine.LFD.2.00.1102241536120.31831@xanadu.home>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com> <1298573197.2428.457.camel@twins> <20110224201124.138311ba@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6> <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
 <1298579452.5226.834.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Peter Zijlstra wrote:

> On Thu, 2011-02-24 at 15:24 -0500, Nicolas Pitre wrote:
> 
> > Most SMP ARM processors are going to use it soon.  Powering down idle 
> > cores provides substantial power saving.
> 
> And why can't regular idle paths be used? CPU hotplug is a massively
> expensive operation.

The idle path assumes that the CPU state is preserved.  We're talking 
about cores completely going down with power pulled beneath them and 
eventually rebooted dynamically here.


Nicolas
