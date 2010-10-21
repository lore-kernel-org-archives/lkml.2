Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0JURFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:05:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60744 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0JURF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:05:29 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7H4gtZfF4z_Vbyr89p4A:9 a=2bvP1MXvL_8CGxAiT4oUCbkIiFMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <alpine.LFD.2.00.1010211817540.2418@localhost6.localdomain6>
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
	 <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
	 <1287496495.16971.372.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
	 <20101019142820.GA14520@Krystal>
	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
	 <1287521757.16971.397.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>
	 <1287523439.16971.433.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010192359480.6815@localhost6.localdomain6>
	 <1287527634.16971.536.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010211817540.2418@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 13:05:25 -0400
Message-ID: <1287680725.16971.586.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 18:18 +0200, Thomas Gleixner wrote:
> 
> On Tue, 19 Oct 2010, Steven Rostedt wrote:
> 
> > On Wed, 2010-10-20 at 00:04 +0200, Thomas Gleixner wrote:
> > 
> > > hpa just posted code which does the _RIGHT_ _THING_ independent of any
> > > compiler madness and you tracer folks just missed it.
> > 
> > Thomas,
> > 
> > Can you try this patch and see if it makes the object code better?
> 
> Nope, same result.

Yeah, I figured. Do you have CC_OPTIMIZE_FOR_SIZE set? And if you do,
what happens if you disable it?

-- Steve


