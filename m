Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1LVBbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:31:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:34578 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab1LVBbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:31:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104859482"
Subject: Re: [tip:sched/urgent] sched: Fix select_idle_sibling() regression
 in selecting an idle SMT sibling
From: "Alex,Shi" <alex.shi@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <1324496556.21294.11.camel@sbsiddha-desk.sc.intel.com>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
	 <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
	 <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
	 <1324471944.10752.8.camel@twins>
	 <1324496556.21294.11.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Dec 2011 09:31:42 +0800
Message-ID: <1324517502.17054.174.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Even with this fix, the loopback netperf testing TCP-RR, still have
> > > about 5% regresion on our 2 socket * 8 cores SNB machine.
> > > which is your patchset includes all cleaning? wondering if that is helpful.
> > 
> > Sorry, but that question fails to parse here. What were you asking?

This patch partly fixed a performance regression that triggered by
4dcfe1025b513c2c, but issue still exists.
> 
> Yes Alex. You need to elaborate your question. Regression to what kernel
> etc?
> 
> Also there is another known issue that's been addressed in -tip. Here is
> that patch. https://lkml.org/lkml/2011/12/21/137

Thanks! 
I am testing whole tip changes against 3.2-rc6. On the 4dcfe1025b513c2c
commit, seems interrupts is abnormal. So maybe above fix is suit for
this issue. wait the results. 



