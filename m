Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0KJTQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:16:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab0KJTQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:16:27 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Mf1wP9fDpHvxvTNziVgA:9 a=iEOQVBC_XbCE7lvVLpu3-w9K0T8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1289413460.2084.27.camel@laptop>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop>  <20101110174852.GB4001@elte.hu>
	 <1289412329.12418.177.camel@gandalf.stny.rr.com>
	 <1289413460.2084.27.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 14:16:24 -0500
Message-ID: <1289416584.12418.184.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 19:24 +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 13:05 -0500, Steven Rostedt wrote:
> > 
> > Peter said at LPC that the perf buffering system was not designed to
> > handle high speed tracing. But he also said he does not like the way the
> > ftrace buffering works. 
> 
> You're not very good at listening,

Or I'm not good at rephrasing, but both are probably true ;-)


>  I said the perf infrastructure and
> event handling mechanism isn't geared towards full throughput but
> instead on sampling.

OK, not the buffering, but the infrastructure. That's not much of a
difference to this topic. Which is about the ABI which includes all from
the user to the buffer.

> 
> There is lots of code between getting the event and landing it in the
> buffer. The buffer itself is perfectly suited for high speed low
> overhead stuffs, the perf data format possibly not because its not
> bitfield happy.

Well, we need to separate out the buffer in perf regardless, since it is
very entwined in the code. Does it now support flight recorder mode?

-- Steve


