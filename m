Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1HFBFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 21:05:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51431 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1HFBFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 21:05:21 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=JVmKiHRY1FkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FYMGy93wqfWvrzvUp2QA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <4E3C85B0.7090905@gmail.com>
References: <20110805205921.909038487@goodmis.org>
	 <4E3C85B0.7090905@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 05 Aug 2011 21:05:19 -0400
Message-ID: <1312592719.18583.219.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 18:07 -0600, David Ahern wrote:
> On 08/05/2011 02:59 PM, Steven Rostedt wrote:
> > Hi All,
> > 
> > I've spent the week working on getting libparsevent.a working with
> > perf. After several rewrites, hacking in both perf and the trace-cmd
> > code, and breaking both beyond repair, I finally got to a point that
> > it just works.
> 
> Does this version allow use of the trace-cmd plugins with perf?
> Specifically, kvm tracing is not compatible with perf (perf barfs on the
> kvm_exit traces); I suspect the plugins would fix that - as well as have
> the pretty format for the exit reasons.
> 
> I want to try out the patch set, but will not have time until the week
> of the kvm forum/linuxcon.
> 

I posted this patch set as an RFC as I don't have time to waste on doing
more work, and I knew it would cause some controversy.

That said, this patch set does not yet add the plugins, but it lays the
ground work for adding plugins to perf in the next step. I probably
could get plugins working with perf by next week. If we keep going in
this direction, otherwise, probably not till next year.

-- Steve


