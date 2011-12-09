Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1LIAlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:41:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:48779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1LIAls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:41:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83826474"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Date: Thu, 8 Dec 2011 16:41:30 -0800
Subject: RE: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Topic: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Index: Acyz80FWSVwMVpHLRvmP5EOvAk1d4wCFa5bQ
Message-ID: <43F901BD926A4E43B106BF17856F075501A23A3010@orsmsx508.amr.corp.intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
In-Reply-To: <20111206084230.GC30062@elte.hu>
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

> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> Then if demand for this picks up some more intelligent method of
> cooperating with the firmware could be added: the firmware could
> actually signal to us whether it supports suspend/resume from
> other than the boot CPU.

We started to think how to handle the resume issue in firmware,
e.g. the way you talked, or change boot CPU to another online CPU
to execute resume procedure.

A firmware solution is a long run. Currently we don't suspend/hibernate
when BSP is offline. If a firmware solution is available, we can
change the sanity check to allow suspend/hibernate if CPU0 is offline
for new firmware. But even when the solution is available in new
firmware, we still need to do the same sanity check on legacy firmware.

Thanks.

-Fenghua
