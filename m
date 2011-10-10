Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1JJM6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:58:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:55316 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1JJM63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:58:29 -0400
Subject: Re: [PATCH 2/3][RFC] tracing: Add optional percpu buffers for
 trace_printk()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1318250240.7904.74.camel@gandalf.stny.rr.com>
References: <20111008170227.792806635@goodmis.org>
	 <20111008171259.462646120@goodmis.org> <1318244913.14400.19.camel@laptop>
	 <1318250240.7904.74.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 15:04:33 +0200
Message-ID: <1318251873.14400.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 08:37 -0400, Steven Rostedt wrote:

> This will make debugging some of my embedded boards difficult (the ones
> where I have no way to add kernel command lines). If there's a problem
> at boot up, I will have to modify the kernel to get this to print.
> 
> For those that don't know the tracing code, it will just simply break.
> 
> Unless you want me to keep the kconfig option that enables it
> permanently. Then I could do this.

There's a fairly easy fix for that, initialize it at boot, and free once
userspace it up and running if no trace_printk() came by.

> I also expect tglx to throw frozen sharks at me for "why doesn't
> trace_printk() work anymore?!!!!"

I'm sure you'll get over that :-)

