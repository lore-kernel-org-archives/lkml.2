Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336Ab0COQQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:16:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965237Ab0COQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:16:06 -0400
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=ecLG9kMwxUnGcq0mVqMA:9 a=2u0y-3sBY4QWkc4jnB-u7u8zilIA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <1268663990.4471.808.camel@gandalf.stny.rr.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>
	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>
	 <4B95AE4E.6060700@cn.fujitsu.com>
	 <1268101394.10871.1861.camel@gandalf.stny.rr.com>
	 <4B95C2AF.7010508@cn.fujitsu.com>
	 <1268446049.4471.787.camel@gandalf.stny.rr.com>
	 <1268502976.4471.798.camel@gandalf.stny.rr.com>
	 <4B9D915A.6080101@cn.fujitsu.com>
	 <1268663990.4471.808.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 15 Mar 2010 12:16:03 -0400
Message-ID: <1268669763.4471.810.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 10:39 -0400, Steven Rostedt wrote:

> > As I said in the offline mail, this warning is caused by global trace_clock,
> > and I sent a fix sometime ago:
> > 
> > http://lkml.org/lkml/2009/12/21/4
> 
> Ah, I was waiting for a final Acked-by: from Peter Zijlstra.
> 
> Peter,
> 
> Should I pull in that patch? I don't see anything wrong with converting
> a raw_local_irq_save() to a local_irq_save() in the tracing code. I'll
> apply it locally and see if it fixes the warn on that I see.

Peter,

I ran the stress test for an hour without any lockdep warnings with Li's
patch. Normally it would trigger in a second. Can I get your acked-by?

Thanks,

-- Steve


