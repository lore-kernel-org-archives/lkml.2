Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab1LFO7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:59:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:28671 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1LFO7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:59:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,306,1320652800"; 
   d="scan'208";a="82769045"
From: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Date: Tue, 6 Dec 2011 06:58:59 -0800
Subject: RE: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Topic: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Index: Acyz9YgY2wUNVuxsT/K7TQr//xnXVAAMgbNw
Message-ID: <26E9B811E137AB4B95200FD4C950886BFFB4653B@orsmsx507.amr.corp.intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu> <20111206085816.GA11116@elte.hu>
In-Reply-To: <20111206085816.GA11116@elte.hu>
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

> But the hibernation angle should be considered. Hibernation already has to deal
> with the case where someone physically unplugs a CPU and then resumes from
> the disk image, right? How does the hibernation code handle that case
> currently?

it'll fail the resume.

