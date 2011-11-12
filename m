Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1KLBGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:06:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:19907 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab1KLBGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:06:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,497,1315206000"; 
   d="scan'208";a="73831169"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Date: Fri, 11 Nov 2011 17:06:26 -0800
Subject: RE: [PATCH v3 1/7] x86/topology.c: Support functions for BSP
 online/offline
Thread-Topic: [PATCH v3 1/7] x86/topology.c: Support functions for BSP
 online/offline
Thread-Index: Acygnx3SxJGK9nN3R1SdWvmU+EShEQAN+wxw
Message-ID: <493994B35A117E4F832F97C4719C4C0401D887FB36@orsmsx505.amr.corp.intel.com>
References: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
 <1320885257-16647-2-git-send-email-fenghua.yu@intel.com>
 <20111111182328.GA8615@phenom.dumpdata.com>
In-Reply-To: <20111111182328.GA8615@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +static int bsp_hotpluggable;
> 
> __read_mostly

Actually bsp_hotpluggable is read only once during boot time. So if changing it, I would change it to __initdata.

Thanks.

-Fenghua
