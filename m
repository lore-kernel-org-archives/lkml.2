Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1JCKd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:33:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:49833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab1JCKdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:33:53 -0400
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 03 Oct 2011 12:33:08 +0200
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
	 <1317355529.4588.45.camel@gandalf.stny.rr.com>
	 <20110930041424.GH10425@mtj.dyndns.org> <1317371699.19415.6.camel@twins>
	 <20110930085510.GA23868@mtj.dyndns.org> <1317373473.19415.10.camel@twins>
	 <20111003011506.GE31799@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317637988.20367.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 12:20 +0200, Peter Zijlstra wrote:
> I didn't write this change for fun, I actually need to get
> PF_THREAD_BOUND back to sanity, this change alone isn't enough, but it
> gets rid of the worst abuse. This isn't frivolous perturbation. 

Not to mention it gets rid of ~250 lines, and it adds stricter checking
and thereby removes the need to manually flush queues if you really
meant things to be per-cpu.

I mean, really, what's the downside?
