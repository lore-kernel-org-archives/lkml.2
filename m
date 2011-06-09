Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1FIDUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:20:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:57758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab1FIDUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:20:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,340,1304319600"; 
   d="scan'208";a="9653522"
Date: Thu, 9 Jun 2011 11:34:32 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v4] x86, vt-d: enable x2apic opt out
Message-ID: <20110609153432.GA12741@linux-youquan.bj.intel.com>
References: <1306341418-10645-1-git-send-email-youquan.song@intel.com> <20110525205843.GC28397@elte.hu> <alpine.LFD.2.02.1105252359460.3078@ionos> <1306366670.2029.46.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306366670.2029.46.camel@i7.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Is that going to make these broken BIOSes fall over too? If so, it
> really does look like the placement of this bit in the DMAR table is
> entirely wrong.
> 
> Rajesh, can you tell use *exactly* what is the BIOS brokenness that this
> hack was invented to work around?
> 
Hi Ingo and David,

IMO, the OPT-OUT flag is not good solution to workround BIOS or platform
issues. 
But some custmoers really requires it to 1) meet their business target.
2) some components in OEM platforms have issue if they generate
platform-events like SMI, or SMM handlers, some interrupt from LAPIC,
because they does not go through VT-d,so they do not know CPU in x2APIC
or xAPIC. 

Can you take it to maintainer tree? 
It will be better for OSVs integration. 
   
Thanks
-Youquan
