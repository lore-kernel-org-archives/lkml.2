Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1LVB6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:58:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:18830 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1LVB6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:58:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88328351"
Subject: Re: [tip:sched/urgent] sched: Fix select_idle_sibling() regression
 in selecting an idle SMT sibling
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 21 Dec 2011 18:03:13 -0800
In-Reply-To: <1324517502.17054.174.camel@debian>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
	 <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
	 <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
	 <1324471944.10752.8.camel@twins>
	 <1324496556.21294.11.camel@sbsiddha-desk.sc.intel.com>
	 <1324517502.17054.174.camel@debian>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324519393.21294.20.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 17:31 -0800, Shi, Alex wrote:
> This patch partly fixed a performance regression that triggered by
> 4dcfe1025b513c2c, but issue still exists.

So how much was the regression caused by the commit 4dcfe1025b513c2c and
how much did we recover with this fix I posted. If we are talking about
the regression caused by this single commit 4dcfe1025b513c2c, then I
don't know of any other related fixes other than the recent fix we
pushed upstream (ab2789213d224202237292d78aaa0c386c7b28b2).

thanks,
suresh

