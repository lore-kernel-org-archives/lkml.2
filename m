Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2FFIkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:40:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:59437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2FFIku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:40:50 -0400
Message-ID: <1338972038.2749.75.camel@twins>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2012 10:40:38 +0200
In-Reply-To: <20120605221240.GW2388@linux.vnet.ibm.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	 <1338912565.2749.9.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	 <1338913190.2749.10.camel@twins>
	 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	 <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos>
	 <1338925756.2749.36.camel@twins> <alpine.LFD.2.02.1206052153200.3086@ionos>
	 <1338931856.2749.57.camel@twins> <20120605221240.GW2388@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 15:12 -0700, Paul E. McKenney wrote:
> > Well, no not like that, but I think we could do with some coupling
> > there. Like steer active interrupts away when they keep hitting idle
> > state.
> 
> But the guys who are more fanatic about performance than about energy
> efficiency would -want- the interrupts to hit the idle CPUs, right? 

Yeah, this is why you want a performance/power knob somewhere.
