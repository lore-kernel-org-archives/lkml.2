Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2FEQCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:02:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:48002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab2FEQCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108105139"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Topic: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Index: AQHNQoAPrrSeWa27GkKpGKrFiBcRb5brDNOAgAAGFYCAAEURgIAAdQ+AgAAVOjA=
Date: Tue, 5 Jun 2012 16:02:03 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
	 <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
 <1338881971.28282.150.camel@twins>
In-Reply-To: <1338881971.28282.150.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Tuesday, June 05, 2012 12:40 AM
> To: Rusty Russell
> Cc: Thomas Gleixner; Yu, Fenghua; Ingo Molnar; H Peter Anvin; Siddha,
> Suresh B; Luck, Tony; Mallick, Asit K; Arjan Dan De Ven; linux-kernel;
> x86; linux-pm; Srivatsa S. Bhat
> Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait
> or nmi
> 
> On Tue, 2012-06-05 at 10:10 +0930, Rusty Russell wrote:
> > I disagree.  Deactivating a cpu for power saving is halfway to
> hotplug
> > anyway.
> 
> No, that's only so for broken hardware. On sane hardware idling is
> sufficient.

Users can consolidate processes on a few online CPU's and offline the rest when workload is light. This consolidation can save more power and have better performance than idling CPU's because hot cache in online CPU's and offline CPU's can be allocated in same package.

Thanks.

-Fenghua
