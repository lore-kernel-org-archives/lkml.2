Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2APP6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:58:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2APP6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:58:46 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KHR86nk1PkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=67cctG__aU3_VJJcc88A:9 a=giQXQ_IR4Q78TMTjETAA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326729524.7642.151.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 16 Jan 2012 10:58:44 -0500
In-Reply-To: <20120116150307.GA12817@redhat.com>
References: <20120110174509.GA30802@redhat.com>
	 <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com>
	 <20120116074540.GE15641@elte.hu> <20120116150307.GA12817@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 16:03 +0100, Oleg Nesterov wrote:

> > Which apps/tools rely
> > on the old tracepoint? If it's exactly zero apps then we might
> > be able to change it, but this needs to be investigated.
> 
> If only I knew. How can we investigate this? Hopefully nothing
> relies on the old tracepoint, but who knows.

I remember Linus saying that we break ABI all the time. It's when
someone complains about it that we revert the breakage.

The chances that an app is using this tracepoint is slim. The chances
that an app is using this tracepoint *and* requires the data structure
size to remain the same is miniscule.

> 
> OK. So we should add the new tracepoint. Looks a bit ugly, but
> I understand your concerns.

And it can bloat the kernel. Each tracepoint can add up to 5K in size.
I'm still working on fixing that.

-- Steve


