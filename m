Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033Ab2FDWDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:03:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:2528 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab2FDWDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:03:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160880851"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Topic: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Index: AQHNQoAPFj9sktPv9UGlpY91mwdZJJbrDNOA//+Lt1A=
Date: Mon, 4 Jun 2012 20:18:42 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F7F17@ORSMSX104.amr.corp.intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1206042203590.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206042203590.3086@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm working on a proper state machine driven online/offline sequence,
> where you can put the cpu into an intermediate state which avoids
> bringing it down completely. This is enough to get the full
> powersaving benefits w/o having to go through all the synchronization
> states of a full online/offline. That will shorten the onlining time
> of an previously offlined cpu to almost nothing.

Will this also be a step towards Fenghua's goal of being able to
take cpu#0 away. I.e. will your state machine be fully symmetric
and allow for cpu#0 to enter this intermediate mostly-offline state?

-Tony
