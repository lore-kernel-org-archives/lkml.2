Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1AZSzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:55:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1AZSzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:55:10 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=nczvMn_Z4IEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2EbY2RAQfYB8fyh7Oh4A:9 a=LL3eiu7QgPDvTTHPuQLFdZSHV9EA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] [GIT PULL][v2.6.38] tracing: fix unaligned event
 arrays
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110126064723.GA15752@elte.hu>
References: <20110126040459.289776311@goodmis.org>
	 <20110126064723.GA15752@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 26 Jan 2011 13:55:07 -0500
Message-ID: <1296068107.10144.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 07:47 +0100, Ingo Molnar wrote:

> > Mathieu Desnoyers (3):
> >       Introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections
> >       tracing: Fix sparc64 alignment crash with __u64_aligned/U64_ALIGN()
> >       tracepoints: Use __u64_aligned/U64_ALIGN()
> > 

> Pulled, thanks a lot Steve!
> 
> 	Ingo


Hi Ingo,

We (well Peter really) just discovered that this can cause alignment
issues with gcc 4.4.4 and 4.4.5 (I unfortunately only tested it with gcc
4.5.1). We are currently looking into fixing it.

Letting you know so that you don't push this off to Linus ;-)

-- Steve


