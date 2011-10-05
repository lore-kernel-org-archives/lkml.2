Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935537Ab1JEXFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 19:05:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:3245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935493Ab1JEXFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 19:05:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60331241"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 5 Oct 2011 16:05:21 -0700
Subject: RE: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
Thread-Topic: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
Thread-Index: AcyDk+q7TcaTmsh+Rl6W+FDtfK3rcQAGE+mg
Message-ID: <493994B35A117E4F832F97C4719C4C040136F7CECC@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-7-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052113370.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110052113370.18778@ionos>
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
> > +	 * Suspend/resume depends on BSP. Certain PCI quirks (which PCI
> > +	 * quirks??) require not to enable hotplug control for all CPU's.
> 
> Again, you dammit better make shure which quirks break when cpu0 is
> offlined.
> 

Maybe I misunderstood the comment in arch/x86/kernel/topology.c

+        * Also certain PCI quirks require not to enable hotplug control
+        * for all CPU's.
+        */

and commit b0d0a4ba45760b10ecee9035ed45b442c1a6cc84

So there is NO PCI quirks dependency on CPU0 hotplug.

I'm going to send out a new cpu0 online/offline patch set after collecting all the comments so far.

Thanks.

-Fenghua
