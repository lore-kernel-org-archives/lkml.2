Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1EJOnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:43:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34695 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1EJOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CY5OkqQQRFkLFpSctzBExm9xOxyDSPg1mpAWfKQE9buOF3+o8xT/voaHZ8fPCHh+AY
         bLm/Ys376Aoa9qHs5ENvMogGMhyOTIL9/nf7yCper59HM/XjeYXHyUOyUBk7S/GeBbon
         6P2Mn7wv7R48jCYYhBY8nEseDO+tAOIrVd3Is=
Date: Tue, 10 May 2011 16:29:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Jiri Olsa <jolsa@redhat.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>
Subject: Re: [RFC][PATCH 00/13] ftrace: Allow multiple users to pick and
 choose functions to trace
Message-ID: <20110510142947.GB4855@nowhere>
References: <20110506152624.776982312@goodmis.org>
 <20110510080029.GA27426@elte.hu>
 <1305016338.2968.19.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305016338.2968.19.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 04:32:18AM -0400, Steven Rostedt wrote:
> On Tue, 2011-05-10 at 10:00 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> 
> > Well, i think we'd like to see the end result as well: i.e. function tracing 
> > exposed to a tracer that can do per task tracing (perf) and then demonstrating 
> > that independent tracing sessions can trace functions without impacting each 
> > other.
> 
> This could be done. I just wanted to post this RFC for now, just in case
> someone found an issue with this design. When I get back home, I'll
> complete this, and work with Frederic to get a RFC patch set with perf
> working.
>
> I don't want to rush this out as it can get complex and I want us to
> "learn" the correct way of enabling this for perf. Although, it would be
> nice to get this into 2.6.40. Perhaps we should be conservative and aim
> for 2.6.41 and let it settle for a release.

In fact getting the function tracer able to run with multi users and
making it usable by perf are two different (although for the same final
purpose) and complicated tasks on their own.

Thus it seems to me more reasonable to advance step by step like we are doing.
