Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1CICTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:19:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:16949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab1CICTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:19:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,287,1297065600"; 
   d="scan'208";a="895270061"
Date: Wed, 9 Mar 2011 10:19:30 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        chris <chris@chris-wilson.co.uk>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20110309021930.GB19224@yliu-dev.sh.intel.com>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
 <20110308232258.GA25987@Krystal>
 <1299627175.20306.96.camel@gandalf.stny.rr.com>
 <20110309000753.GA27729@Krystal>
 <1299629657.20306.105.camel@gandalf.stny.rr.com>
 <20110309002921.GA744@Krystal>
 <1299631924.20306.122.camel@gandalf.stny.rr.com>
 <20110309020131.GA19224@yliu-dev.sh.intel.com>
 <1299636734.20306.134.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299636734.20306.134.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 09:12:14PM -0500, Steven Rostedt wrote:
> On Wed, 2011-03-09 at 10:01 +0800, Yuanhan Liu wrote:
> 
> > > Users are for testing code ;)
> > 
> > As another end-user, this looks fine (also simple) to me ;)
> 
> Ah, you find this patch I have simple?

Nop, I mean the way to enable it.

> 
> > 
> > > 
> > > But that's a good question. As I wrote this because I'm purging my inbox
> > > and came across Yuanhan Liu's patch set. I'm curios to what Yuanhan's
> > > motivation for this change was.
> > 
> > The motivation of my original patch is simple: try to not miss any trace
> > events. I guess it's a kind of feature that trace(or module) should
> > have ;) 
> 
> Hmm, I probably could add a trace option that simply tells ftrace to
> enable events as modules are loaded.
> 
> Thanks!
> 
> -- Steve
> 
