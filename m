Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0IMTpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:45:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab0IMTpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <20100913182355.GC20171@elte.hu>
References: <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop>
 <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal>
 <1284387398.2275.311.camel@laptop> <20100913161641.GA28707@Krystal>
 <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
 <20100913174533.GA15653@Krystal> <20100913180348.GA20171@elte.hu>
 <20100913181925.GA15107@Krystal> <20100913182355.GC20171@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Sep 2010 12:44:54 -0700
Message-ID: <AANLkTi=TfU6PxDce9WbcQA7tFcT0yY+FqCOUC_cbfj+e@mail.gmail.com>
Subject: Re: [PATCH] sched: Improve latencies under load by decreasing minimum
 scheduling granularity
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 11:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Linus, Mathieu, you can test the granularity reduction patch via:

Hmm. It's a bit hard to judge subjective feelings, especially when you
have expectations of improvement, but yes, I think this does improve
the the interactive feel when scroll-wheeling around in firefox or
chrome.

So on the whole I'd trust the actual latency benchmark numbers more,
but I _think_ it does translate into actually feeling better too.

                          Linus
