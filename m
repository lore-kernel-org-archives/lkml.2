Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab0GVNau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:30:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab0GVNap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:30:45 -0400
X-Authority-Analysis: v=1.1 cv=nxp4sGnGskpld68D65f6QeagdS7Y+3TTkvBhhEd/T4I= c=1 sm=0 a=yRs0Bdu_tHsA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=wZtR6DnZcs-Kr-E7TTIA:9 a=z78LK7oIcF5OVBJ380GkSq88Z38A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH v1 06/15] perf: export tracepoint events via
 sysfs: iwlwifi and iwlwifi_io
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <1279797640.12439.11.camel@jlt3.sipsolutions.net>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
	 <1279797640.12439.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jul 2010 09:30:40 -0400
Message-ID: <1279805440.3319.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 13:20 +0200, Johannes Berg wrote:
> On Thu, 2010-07-22 at 19:13 +0800, Lin Ming wrote:
> > iwlwifi and iwlwifi_io tracepoint events are exported like below,
> 
> >  drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++++++++
> >  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> err, how about iwlagn?


A lot of work went into making the include/trace/events/*.h be able to
automate the work. Now it seems that we are going to hand code a lot,
and a developer that adds a new system or such will now need to
understand the internals of perf to use it. That was what I strived to
avoid when creating the TRACE_EVENT() macros.

-- Steve


