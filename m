Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1LUThk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:37:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:1871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1LUThg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:37:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88223704"
Subject: Re: [tip:sched/urgent] sched: Fix select_idle_sibling() regression
 in selecting an idle SMT sibling
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: alex shi <lkml.alex@gmail.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "efault@gmx.de" <efault@gmx.de>, "Shi, Alex" <alex.shi@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 21 Dec 2011 11:42:36 -0800
In-Reply-To: <1324471944.10752.8.camel@twins>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
	 <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
	 <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
	 <1324471944.10752.8.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324496556.21294.11.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 04:52 -0800, Peter Zijlstra wrote:
> On Wed, 2011-12-21 at 20:33 +0800, alex shi wrote:
> > > Fix it. Slightly bigger patch of cleaning all these goto's etc
> > > is queued up for the next release.
> > >
> > 
> > Even with this fix, the loopback netperf testing TCP-RR, still have
> > about 5% regresion on our 2 socket * 8 cores SNB machine.
> > which is your patchset includes all cleaning? wondering if that is helpful.
> 
> Sorry, but that question fails to parse here. What were you asking?

Yes Alex. You need to elaborate your question. Regression to what kernel
etc?

Also there is another known issue that's been addressed in -tip. Here is
that patch. https://lkml.org/lkml/2011/12/21/137

Please try and if you still see an issue, please report more details
about the regression you are seeing.

thanks,
suresh

