Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1AXWqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:46:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64285 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1AXWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fB4pOGiBlStQ9mosMh1qKo/DiNywdNABQPicsjWVEoJb0fsBg9M0amuAlXn0HZ37vq
         LE5ktTXqu5jP60rtrnjGnJtD+qjAKLr/j0T/eSdVcW+NvwSCUUuVri98n3sZ/P73GKeQ
         kHTUNbDRQAPXtdvUQdqlYmo2f/At1CmnJT5gc=
Date: Mon, 24 Jan 2011 23:46:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, tardyp@gmail.com,
        jean.pihet@newoldbits.com, linux-perf-users@vger.kernel.org,
        mathieu.desnoyers@efficios.com, linux-trace-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Perf ABI versioning
Message-ID: <20110124224610.GF2318@nowhere>
References: <201101241704.01021.trenn@suse.de>
 <201101242249.14471.trenn@suse.de>
 <20110124215755.GE6367@ghostprotocols.net>
 <201101242330.03008.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101242330.03008.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:30:01PM +0100, Thomas Renninger wrote:
> On Monday 24 January 2011 22:57:55 Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jan 24, 2011 at 10:49:13PM +0100, Thomas Renninger escreveu:
> ... 
> > Using the /format file hashed as peterz said is elegant, fine grained
> > content based ABI number :-)
> Ok thanks, I should have had a closer look at the binary format.
> 
> It may make sense at some time to provide a library so that other tools
> can make use of the most convenient functions in tools/perf/utils/*
> as well?

I personally wish the other way around: having Pytimechart merged in perf :)
If I remember correctly, the problem was that we don't have support for
trace_printk with perf?

But sure if more out of tree tools show up and want to use tracepoints,
we can think about librarizing it.

(Even though my secret hope is that
we build a nice one tool that can answer most tracing needs together rather
than many scattered ad hoc pieces.)
