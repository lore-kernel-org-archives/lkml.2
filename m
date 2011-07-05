Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab1GENew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:34:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:35840 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1GENeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:34:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,479,1304319600"; 
   d="scan'208";a="23993941"
Subject: Re: [PATCH 2/4] perf, x86: Add Intel Nhm/Wsm/Snb load latency
 support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309871868.3282.149.camel@twins>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-3-git-send-email-ming.m.lin@intel.com>
	 <1309871868.3282.149.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 21:34:47 +0800
Message-Id: <1309872887.2381.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 21:17 +0800, Peter Zijlstra wrote:
> On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> > +#define INTEL_EVENT_EXTRA_REG2(event, msr, vm)    \
> > +       EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
> > +                       ARCH_PERFMON_EVENTSEL_UMASK, vm) 
> 
> That's inconsistent wrt the normal constraints, INTEL_UEVENT_EXTRA_REG
> would be the consistent name.
> 
> #define INTEL_UEVENT_EXTRA_REG(event, msr, vm)	\
> 	EVENT_EXTRA_REG(event, msr, INTEL_ARCH_EVENT_MASK, vm)

Right, thanks.


