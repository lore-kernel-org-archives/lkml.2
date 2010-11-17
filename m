Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162Ab0KQRwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:52:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935128Ab0KQRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:52:38 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=VINkOuZDQI4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=hduEXUPig9IjSzm5EHUA:9 a=tMOqPnvxjMe6CLlyx_VAv7Aki7QA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20101117174652.GC13717@Krystal>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de>
	 <20101117103914.GA21976@elte.hu>
	 <1289996753.30543.35.camel@gandalf.stny.rr.com>
	 <20101117174652.GC13717@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 12:52:34 -0500
Message-ID: <1290016354.30543.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 12:46 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> [...]
> > Are these events now going to be labeled as stable?  Is every tracepoint
> > we have, much have the same data?  Linus specifically said at Kernel
> > Summit that he wants absolutely NO modules to have a stable tracepoint.
> 
> I'd like to bring up the point of KVM tracepoints here. KVM can be configured as
> a module, and may clearly contain tracepoints that we'd like to be stable.
> 
> My thought is that what we really want to enforce is "no stable tracepoints in
> drivers" rather than in "modules", but I might be wrong.
> 
> Thoughts ?

I still say no to stable tracepoints in modules. Once you open that
door, everyone will have it.

But, that doesn't mean that a raw traepoint can't be stable. If the
maintainer of that tracepoint states it is stable, then by all means,
let tools use it.

-- Steve


