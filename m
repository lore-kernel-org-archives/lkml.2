Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab0KQNx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:53:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:33384 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0KQNx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:53:56 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101117134300.GG5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere>
	 <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop>
	 <20101117125344.GC5464@nowhere> <1289998957.2109.751.camel@laptop>
	 <20101117131023.GE27063@elte.hu> <1290000976.2109.782.camel@laptop>
	 <20101117134300.GG5464@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 14:53:49 +0100
Message-ID: <1290002029.2109.799.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:43 +0100, Frederic Weisbecker wrote:
> 
> > Yes, trace_printk() is a pure debug interface, solely meant for the edit
> > + reboot cycle.
> 
> So why prevent from making it even more handy?
> 
> 
> > If you want anything more than that we've got tracepoints. The rule up
> > until now has been to never merge a trace_printk() user.
> 
> Sure, that doesn't change the core idea of trace_prink(): none of them must
> be merged. That new event interface would just make private uses of trace_printk()
> more convenient. 

I don't get it, if you don't want it, why put it there in the first
place?

I've never found myself thinking, oh damn, I didn't want to see that
one!, only damn, I should have added more :-)
