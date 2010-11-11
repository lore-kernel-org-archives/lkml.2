Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0KKVPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:15:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:50294 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0KKVPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:15:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,184,1288594800"; 
   d="scan'208";a="676651301"
Subject: Re: [RFC -tip] x86, apic: Merge x2apic code
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101111205955.GC6517@lenovo>
References: <20101110192053.GA6978@lenovo>
	 <1289508257.2680.182.camel@sbsiddha-MOBL3.sc.intel.com>
	 <20101111205955.GC6517@lenovo>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 11 Nov 2010 13:15:52 -0800
Message-Id: <1289510152.2680.185.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 12:59 -0800, Cyrill Gorcunov wrote:
> On Thu, Nov 11, 2010 at 12:44:17PM -0800, Suresh Siddha wrote:
> > On Wed, 2010-11-10 at 11:20 -0800, Cyrill Gorcunov wrote:
> > > Hi, while being at x2apic_x.c code I noted that files look similar to
> > > each other so I guessed may be we could merge them. As result --
> > > this patch.
> > 
> > BTW, as you noticed, x2apic cluster mode allows IPI's to be sent to
> > multiple cpu's (in the same cluster) at once. I was hoping sometime I
> > will do this to see if it helps in anything.
> > 
> > So once we do that IPI code will look different.
> 
> yes, indeed, so enlight me a bit -- we have to map every cpu number from
> cpumask to apic-id, then figure out if it belongs to same cluster, collect
> such apic-ids and then send one ipi with one cluster and multiple apic-id
> bits as a destination,

correct.

>  or I miss something and there _can't_ ever be the
> situation when first 16 cpus from cpumask belong to different clusters?

There is no such assumption.

thanks,
suresh

