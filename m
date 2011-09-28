Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1I1RK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:10:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1I1RK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:10:27 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=v1jNb7L17ooA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=pGLkceISAAAA:8 a=ZWt8V4ykeEwZt0GFfzAA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Date: Wed, 28 Sep 2011 13:10:24 -0400
In-Reply-To: <20110928165639.GA10084@elte.hu>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
	 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
	 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
	 <1317044192.26514.1.camel@gandalf.stny.rr.com>
	 <20110926145606.GA8886@jolsa.brq.redhat.com>
	 <20110928135525.GS18553@somewhere>
	 <1317218589.4588.4.camel@gandalf.stny.rr.com>
	 <20110928141754.GT18553@somewhere> <20110928165639.GA10084@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317229825.4588.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good to see your email is back :)


On Wed, 2011-09-28 at 18:56 +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > > But it seems Steve's patches are not completely uncontroversial 
> > > > because of some crazy disagreements on where the 
> > > > libparsevent.so should lay (tools generic or tied to perf).
> > > 
> > > Which to me seems to be a silly road block, in which I never got 
> > > a clear answer for.
> > 
> > Yeah we need to sort that out with Ingo.
> 
> Basically, since it's not at all clear to me where these things (and 
> APIs) will go, I'd be much more comfortable with this starting out as 
> tools/perf/lib/ - we can still split it out later on. Merging it in 
> will be a lot harder.

I would actually argue that merging is much easier than splitting
something up. If A depends on B, merging B back into A is trivial. But
if B is a part of A, breaking it out of A is a much more difficult task,
as the boundaries of A and B are not so easy to find and the coupling of
the two is much tighter.

I find trying to break things out of perf is very hard to do as the
dependencies are throughout all of perf, and no one seems to agree on
how to do so.

-- Steve


