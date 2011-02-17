Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab1BQNS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:18:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38513 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab1BQNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:18:27 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=JGpTz_e83PYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CRm9vzU9Un_mMth3MAUA:9 a=nJOFus3cDdOf2obSFA8eYcZ0GrcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4D5D1672.6070206@hitachi.com>
References: <20110209200249.111932716@goodmis.org>
	 <4D5D1672.6070206@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 08:18:23 -0500
Message-ID: <1297948703.23343.907.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 21:37 +0900, Masami Hiramatsu wrote:

> Oops! with this change, current kprobes might not be able to probe
> the entry of functions, because that is always reserved by ftrace!
> I think we need to have some new interface for replacing each other
> safely...

Good point. I suspect that this wont be ready till .40 anyway. When I
get a chance to work more an this, I'll also include patches where if
-mfentry is activated kprobes will just hook to the mcount caller
instead. Or ftrace itself :)

I'm also working on making the function tracer a bit more flexible. That
is, to let multiple clients control the dynamic trace instead of just
one big global one.

-- Steve


