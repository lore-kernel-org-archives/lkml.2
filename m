Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab0EKHAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:00:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:33332 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab0EKHAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:00:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,206,1272870000"; 
   d="scan'208";a="620622068"
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100511065131.GA31863@elte.hu>
References: <1273483595.15998.56.camel@minggr.sh.intel.com>
	 <1273484430.5605.3334.camel@twins>
	 <1273486670.15998.80.camel@minggr.sh.intel.com>
	 <1273486769.5605.3343.camel@twins> <20100510122728.GB5563@nowhere>
	 <1273496054.5605.3400.camel@twins> <20100510230911.GB5895@nowhere>
	 <1273559935.5605.3418.camel@twins>
	 <1273560280.30322.12.camel@minggr.sh.intel.com>
	 <20100511065131.GA31863@elte.hu>
Content-Type: text/plain
Date: Tue, 11 May 2010 15:00:10 +0800
Message-Id: <1273561210.30322.15.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 14:51 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > On Tue, 2010-05-11 at 14:38 +0800, Peter Zijlstra wrote:
> > > On Tue, 2010-05-11 at 01:09 +0200, Frederic Weisbecker wrote:
> > > 
> > > > Which module do you have in mind that could register a pmu?
> > > > And I don't understand the problem with pci-hotplug.
> > > 
> > > Well, the DRM drivers for one, but basically the trend is for every
> > > aspect of the machine to include PMUs of some form, this includes bus
> > > bridges and fancy devices.
> > 
> > So the concept of "PMU" is really broadened here?
> > Not just only the performance monitoring hardware in CPU?
> 
> We _really_ dont want to call it a 'PMU' but 'events coming from an event 
> source'.
> 
> The reason is that a PMU is an existing term that is quite attached to a CPU - 
> while many hardware events come not from a PMU. Interrupts, error conditions, 
> hotplug events, etc. etc.
> 
> Furthermore, the name 'PMU' is even less correct for software events.
> 
> So lets stick with 'events' and with some container that originates them. 
> (event_source) Ok?

Yeah, understand.
"events coming from an event source" is a good clarification.

Thanks.

