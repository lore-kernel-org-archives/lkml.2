Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1JCNn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:43:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:52037 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1JCNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:43:52 -0400
Date: Mon, 3 Oct 2011 15:43:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <htejun@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
In-Reply-To: <1317637988.20367.13.camel@twins>
Message-ID: <alpine.LFD.2.02.1110031539380.1489@ionos>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>  <20110930034815.GF10425@mtj.dyndns.org>  <1317355529.4588.45.camel@gandalf.stny.rr.com>  <20110930041424.GH10425@mtj.dyndns.org> <1317371699.19415.6.camel@twins>  <20110930085510.GA23868@mtj.dyndns.org>
 <1317373473.19415.10.camel@twins>  <20111003011506.GE31799@mtj.dyndns.org> <1317637988.20367.13.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Peter Zijlstra wrote:

> On Mon, 2011-10-03 at 12:20 +0200, Peter Zijlstra wrote:
> > I didn't write this change for fun, I actually need to get
> > PF_THREAD_BOUND back to sanity, this change alone isn't enough, but it
> > gets rid of the worst abuse. This isn't frivolous perturbation. 
> 
> Not to mention it gets rid of ~250 lines, and it adds stricter checking
> and thereby removes the need to manually flush queues if you really
> meant things to be per-cpu.
> 
> I mean, really, what's the downside?

Nothing. If code can be simplified and at the same time gets stricter
semantics and becomes less fragile then there is no valid reason to
refuse such a cleanup.

Thanks,

	tglx
