Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0H0K6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:58:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39209 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0H0K6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:58:46 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <c065aaeb33752e7fce8958c8501a5a15.squirrel@webmail.greenhost.nl>
References: <20100826180908.648103531@efficios.com>
	 <c065aaeb33752e7fce8958c8501a5a15.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 12:58:33 +0200
Message-ID: <1282906713.1975.2187.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 12:47 +0200, Indan Zupancic wrote:
> 
> Please don't hide scheduler improvements behind obscure CONFIG_SCHED_DEBUG
> options. If it doesn't make the scheduler better just don't merge it. If it
> does then it should be enabled by default. 

It's RFC, features are nice to test things and see if/how they work.
Features are not a user option, so you don't have to worry about them.

Also, 'better' is a very hard thing to quantify. Some people like
throughput, some like latency, and others like raw context switch
performance.

Hopefully we'll soon have a non privileged sporadic task scheduler for
all our srt media needs.
