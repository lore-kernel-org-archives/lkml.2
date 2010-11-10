Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0KJSY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:24:27 -0500
Received: from canuck.infradead.org ([134.117.69.58]:48375 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab0KJSY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:24:26 -0500
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1289412329.12418.177.camel@gandalf.stny.rr.com>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop>  <20101110174852.GB4001@elte.hu>
	 <1289412329.12418.177.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 19:24:20 +0100
Message-ID: <1289413460.2084.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 13:05 -0500, Steven Rostedt wrote:
> 
> Peter said at LPC that the perf buffering system was not designed to
> handle high speed tracing. But he also said he does not like the way the
> ftrace buffering works. 

You're not very good at listening, I said the perf infrastructure and
event handling mechanism isn't geared towards full throughput but
instead on sampling.

There is lots of code between getting the event and landing it in the
buffer. The buffer itself is perfectly suited for high speed low
overhead stuffs, the perf data format possibly not because its not
bitfield happy.




