Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1A0TLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:11:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab1A0TLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:11:42 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=yCYlo0vawIgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=6yZfvqokFKnafgrsGZ0A:9 a=guTeKhVpvlCFJHdLQIy7DHEOtSsA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3] tracepoints: Use __u64_aligned/U64_ALIGN()
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20110127190929.GA5944@elte.hu>
References: <20110126040459.289776311@goodmis.org>
	 <20110126041014.987944521@goodmis.org>
	 <20110127181907.GA5226@jolsa.brq.redhat.com>
	 <1296152551.10144.80.camel@gandalf.stny.rr.com>
	 <20110127190929.GA5944@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 27 Jan 2011 14:11:40 -0500
Message-ID: <1296155500.10144.81.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 20:09 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 2011-01-27 at 19:19 +0100, Jiri Olsa wrote:
> > 
> > > this patch breaks tracepoint section iterating for me
> > > when trying to enable any event I get:
> > 
> > Yep we know. We are currently going through and reverting this with
> > something else.
> 
> For now i've unrolled it from -tip to give this stuff some more time to cook - it's 
> clearly not ready yet.

OK, good, because I was going to revert that anyway :)

I'll make sure the new patches roll on top of what you have in tip.

Thanks!

-- Steve


