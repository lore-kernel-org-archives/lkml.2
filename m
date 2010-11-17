Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab0KQXdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:33:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61774 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab0KQXdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:33:06 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=meSPosxfOXMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=D19gQVrFAAAA:8 a=opNAwP4dILp0_SIRnmEA:9 a=_3CGIoDu73ZJn4_IKsVYZV8PQLIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Benchmarks of kernel tracing options 2 (ftrace, lttng and perf)
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Douglas Santos <douglas.santos@polymtl.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
In-Reply-To: <AANLkTim9f2aNAaF8YgbOH3xKY9pjAtkHOoYVTv+XOE8W@mail.gmail.com>
References: <1290029498.4ce449ba1679d@www.imp.polymtl.ca>
	 <1290030106.30543.74.camel@gandalf.stny.rr.com>
	 <1290034589.4ce45d9d7be28@www.imp.polymtl.ca>
	 <AANLkTim9f2aNAaF8YgbOH3xKY9pjAtkHOoYVTv+XOE8W@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 18:33:02 -0500
Message-ID: <1290036782.30543.84.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:22 -0800, David Sharp wrote:
> On Wed, Nov 17, 2010 at 2:56 PM, Douglas Santos
> <douglas.santos@polymtl.ca> wrote:
> > Quoting Steven Rostedt <rostedt@goodmis.org>:
> >> On Wed, 2010-11-17 at 16:31 -0500, Douglas Santos wrote:
> >> > Hi all,
> >> >
> >> > This is a response to a benchmark, submitted a few weeks ago, comparing
> >> kernel
> >> > tracing options.
> >> > http://lkml.org/lkml/2010/10/28/422
> >> >
> >> > We followed the methodology described in the link bellow,
> >> > but using the shellscripts posted there to reproduce autotest scripts.
> >> > http://lkml.org/lkml/2010/10/28/261
> >> >
> >> > We disabled the extra syscall tracing on lttng, for a fair comparison.
> >> > http://lkml.org/lkml/2010/10/28/290
> >> >
> >> > Average results with tracing "on":
> >> >
> >> > lttng:  220 ns
> >> > ftrace: 260 ns
> >>
> >> Heh, so ftrace got worse with the new kernel?
> 
> Steve, can you explain how you're drawing that conclusion? Did Douglas
> run this benchmark before on a previous kernel (I didn't see it if
> so)?

Oops, no, I was thinking that this was from your tests. I remember
asking you to try the new kernel. I think I got you and Douglas
confused :-)

-- Steve


