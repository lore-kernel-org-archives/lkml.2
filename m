Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab1CCWnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:43:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759019Ab1CCWnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:43:00 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=udRi0BhUxgIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=x7NVS_Hyu7oks7qMQ2QA:9 a=kg0vsNl7OoFLDyGGC9fxIx8--FcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH V6 0/2] tracing, perf: cpu hotplug trace events
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, amit.kucheria@linaro.org, rusty@rustcorp.com.au,
        tglx@linutronix.de, Arjan van de Ven <arjan@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-perf-users@vger.kernel.org
In-Reply-To: <201103022307.46694.trenn@suse.de>
References: <AANLkTinbYWQxde2jTcAtyYQGvGgt2Lmtnph=voj=haXF@mail.gmail.com>
	 <201103021157.08260.trenn@suse.de>
	 <AANLkTi=dht7+bPrBqmt6shHefBxSB3yOUu4OcSvcd0am@mail.gmail.com>
	 <201103022307.46694.trenn@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 03 Mar 2011 17:42:56 -0500
Message-ID: <1299192176.6376.47.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 23:07 +0100, Thomas Renninger wrote:

> I doubt cpu offlining is the proper instrument to save power.
> You want to prevent the CPU of being used by ripping it out from scheduler decisions and
> make sure it doesn't get interrupts by offlining. But the (latency) price is high.

I could imagine that a server could use this for power savings to take
down all but 1 CPU on off hours. When it knows its not going to get much
action but still needs to remain online. Then just before peak times
begin, online the other CPUs.

But anything more dynamic than that, I can't see it really worth it. As
the latency to bring the other CPU online, may miss a peak when it was
needed.

-- Steve


