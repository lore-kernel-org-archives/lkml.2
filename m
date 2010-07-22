Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab0GVNtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:49:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0GVNtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:49:16 -0400
Date: Thu, 22 Jul 2010 15:48:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Lin Ming <ming.m.lin@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH v1 06/15] perf: export tracepoint events via sysfs:
 iwlwifi and iwlwifi_io
Message-ID: <20100722134836.GA6881@elte.hu>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
 <1279797640.12439.11.camel@jlt3.sipsolutions.net>
 <1279805440.3319.2.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279805440.3319.2.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2010-07-22 at 13:20 +0200, Johannes Berg wrote:
> > On Thu, 2010-07-22 at 19:13 +0800, Lin Ming wrote:
> > > iwlwifi and iwlwifi_io tracepoint events are exported like below,
> > 
> > >  drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++++++++
> > >  1 files changed, 15 insertions(+), 0 deletions(-)
> > 
> > err, how about iwlagn?
> 
> A lot of work went into making the include/trace/events/*.h be able to 
> automate the work. Now it seems that we are going to hand code a lot, and a 
> developer that adds a new system or such will now need to understand the 
> internals of perf to use it. That was what I strived to avoid when creating 
> the TRACE_EVENT() macros.

Yeah - and the point of this submission is to allow the discussion of how to 
achieve these registrations.

Driver authors will want to have some control - for example the place where 
the events directory shows up in sysfs within the driver's directory structure 
- etc.

But we indeed want to automate it as much as possible.

Thanks,

	Ingo
