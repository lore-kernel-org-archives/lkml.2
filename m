Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0KJTie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:38:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0KJTid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:38:33 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VHXPlmt6Eqeqluz-GTIA:9 a=bSH1JtwzgEi6Di3h0vzfjRbu_24A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
Date: Wed, 10 Nov 2010 14:38:31 -0500
Message-ID: <1289417911.12418.187.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 19:24 +0100, Peter Zijlstra wrote:
> There is lots of code between getting the event and landing it in the
> buffer. The buffer itself is perfectly suited for high speed low
> overhead stuffs, the perf data format possibly not because its not
> bitfield happy.

Question:

Can we make perf lower what it records, thus speeding up the amount it
records, without breaking the ABI?

Can we add flight recorder mode splice version, non mmap, without
breaking the ABI?

If we can make perf as fast as ftrace in its recording, and maybe even
faster if we have the ability to select what is recorded and compress
the events, I'm all for it.

-- Steve



