Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2HQSrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:47:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42968 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2HQSrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:47:14 -0400
Date: Fri, 17 Aug 2012 19:47:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120817184705.GB13369@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
 <502C98E8.20800@linux.vnet.ibm.com>
 <502CFD35.5000801@linux.intel.com>
 <20120817184100.GA13369@srcf.ucam.org>
 <502E90F3.2000702@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E90F3.2000702@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:44:03AM -0700, Arjan van de Ven wrote:
> On 8/17/2012 11:41 AM, Matthew Garrett wrote:
> > On Thu, Aug 16, 2012 at 07:01:25AM -0700, Arjan van de Ven wrote:
> >> this is ... a dubiously general statement.
> >>
> >> for good power, at least on Intel cpus, you want to spread. Parallelism is efficient.
> > 
> > Is this really true? In a two-socket system I'd have thought the benefit 
> > of keeping socket 1 in package C3 outweighed the cost of keeping socket 
> > 0 awake for slightly longer.
> 
> not on Intel
> 
> you can't enter package c3 either until every one is down.
> (e.g. memory controller must stay on etc etc)

I thought that was only PC6 - is there any reason why the package cache 
can't be entirely powered down?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
