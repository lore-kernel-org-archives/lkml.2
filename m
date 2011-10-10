Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1JJOVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:21:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42400 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab1JJOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:21:33 -0400
Date: Mon, 10 Oct 2011 16:21:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>, acme@redhat.com,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
Message-ID: <20111010142124.GD479@somewhere.redhat.com>
References: <1317028312-5156-2-git-send-email-jolsa@redhat.com>
 <1317044192.26514.1.camel@gandalf.stny.rr.com>
 <20110926145606.GA8886@jolsa.brq.redhat.com>
 <20110928135525.GS18553@somewhere>
 <1317218589.4588.4.camel@gandalf.stny.rr.com>
 <20110928141754.GT18553@somewhere>
 <20110928165639.GA10084@elte.hu>
 <1317229825.4588.12.camel@gandalf.stny.rr.com>
 <20111010052259.GC32173@elte.hu>
 <1318249656.7904.66.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318249656.7904.66.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 08:27:34AM -0400, Steven Rostedt wrote:
> > Please work out disagreements with Arnaldo and do librarization 
> > within perf if you are interested in that angle. If those internal 
> > interfaces become visibly boring and are consistently used by 
> > everything in a way that every main contributor agrees on then we can 
> > perhaps librarize it. Not the other way around.
> 
> For parsing of events, which is what I proposed, it seems to be boring
> technical stuff that has been well established by the limitations of the
> ABI forced on the debugfs system. It's already over a year old and used
> by several developers. One nice feature to come with this is the ability
> to add plugins to parse the trace events without needing to read all the
> format files. Things like kvm events will suddenly work.
> 
> The one disagreement that we are still sorting out is just the name of
> the library. I first said libperf (which would make sense to have in
> tools/perf/lib) but then it wasn't doing perf specific work. It was just
> a way to parse kernel trace points. Nobody seemed to like libparsevent.
> I think one of the names that makes sense is libtrace, or libktrace as
> it has to do with tracepoints in the kernel. Maybe just libktracepoint?
> But that's quite an ugly name.

libtracevent ?
