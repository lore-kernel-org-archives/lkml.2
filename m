Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab0KQMxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:53:55 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49501 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0KQMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sD8SWopYGMr7Ej2vAvV1qfWtwfb9sVrK0XWGX4i1IsxPjf/wmYUCLuapc2h+rRr7a5
         ELnWsSx1l3rgdt+NXAkcqPIb63jXkZclmsVYUFZQzPuRUWCjD8e/JB8iSGOUeiGr3cVe
         xhqEx73KiZudDonGvTIoPOx1Zyy8H37PWnepY=
Date: Wed, 17 Nov 2010 13:53:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117125344.GC5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere> <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289993750.2109.718.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:35:50PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 09:30 +0100, Ingo Molnar wrote:
> > > For example I'm currently working with dozens of trace_printk() and I would be 
> > > very happy to turn some of them off half of the time.
> > 
> > I guess we could try such a patch. If you send a prototype i'd be interested in 
> > testing it out.
> 
> I don't see the point, the kernel shouldn't contain any trace_printk()s
> to begin with..


It's oriented toward developers. Those who use dozens of tracepoints in
their tree because they are debugging something or developing a new feature,
they might to deactivate/reactivate some of these independant points.

This can also apply to dynamic_printk of course.

Well, the very first and main point is to standardize trace_printk into
a trace event so that it gets usable by perf tools. I have been asked many
times "how to use trace_printk() with perf?".

