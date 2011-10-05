Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935367Ab1JEULt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:11:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:54131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935270Ab1JEULs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:11:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60280554"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 5 Oct 2011 13:11:46 -0700
Subject: RE: [PATCH 1/8] x86, apic.c: Disable irq0 if CPU enables ARAT for
 local apic timer
Thread-Topic: [PATCH 1/8] x86, apic.c: Disable irq0 if CPU enables ARAT for
 local apic timer
Thread-Index: AcyDlk82HQEKss6wSo2DgaSjjWAuEgAA9Q2w
Message-ID: <493994B35A117E4F832F97C4719C4C040136F7CC8E@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-2-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052045430.18778@ionos>
 <493994B35A117E4F832F97C4719C4C040136F7CBF3@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.02.1110052129270.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110052129270.18778@ionos>
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

timer
> 
> On Wed, 5 Oct 2011, Yu, Fenghua wrote:
> 
> Please remove Zwane Mwaikambo <zwane@arm.linux.org.uk> from the cc
> list, that address does not exist anymore.

OK. I'll remove his address from the list.

I just got Zwane's address from MAINTAINERS. So his info should be fixed in MAINTAINERS.

SC1200 WDT DRIVER
M:      Zwane Mwaikambo <zwane@arm.linux.org.uk>
S:      Maintained
F:      drivers/watchdog/sc1200wdt.c

I was hoping Zwane knows which PCI quirks depends on CPU0.

Thanks.

-Fenghua
