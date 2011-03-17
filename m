Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1CQDPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:15:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59208 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752610Ab1CQDPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:15:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4CM8zlwy4gKWvRBJyMqzZ7WlGdpGagJYlrBVDbi
	k1l4oYqZ1zqzxJ
Subject: Re: [PATCH 0/4 v3] smp_call_function_many issues from review
From: Mike Galbraith <efault@gmx.de>
To: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, Jan Beulich <JBeulich@novell.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Tony Luck <tony.luck@intel.com>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <smp-call-function-intro-v3@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com> <ipi-list-reply@mdm.bga.com>
	 <smp-cfm-list-comment@mdm.bga.com>
	 <smp-call-function-list-race-fix-v2@mdm.bga.com>
	 <20110201220026.GD2142@linux.vnet.ibm.com> <ipi-paul-reply@mdm.bga.com>
	 <20110202041740.GB2129@linux.vnet.ibm.com>
	 <20110206235136.GA23658@linux.vnet.ibm.com>
	 <smp-call-function-intro-v3@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 04:15:21 +0100
Message-ID: <1300331721.6361.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 13:27 -0600, Milton Miller wrote:
> Picking up this thread from the beginning of Feburary,  I updated
> the comments in 3 and 4 based on Paul's review.  I have inserted
> my proposed alternative to Paul's additional patch as patch 2,
> and tweaked the changelog on 1.
> 
> [PATCH 1/4 v3] call_function_many: fix list delete vs add race
> [PATCH 2/4 v3] call_function_many: add missing ordering
> [PATCH 3/4 v3] smp_call_function_many: handle concurrent clearing of mask
> [PATCH 4/4 v3] smp_call_function_interrupt: use typedef and %pf
> 
> Peter Z acked a prior version of patch 1, and Mike Galbraith has
> done some stress testing on the combinaton of 1,3,4, and Paul's patch.

I beat hell out of all v2 + Paul's ordering patch.  These are verified
to have fixed a nasty enterprise cluster problem.

> The prior posting of this series is available here:
> https://patchwork.kernel.org/patch/522021/
> https://patchwork.kernel.org/patch/522031/
> http://marc.info/?l=linux-kernel&m=129654439817236&w=2
> 
> And Paul's additional patch from review was here
> https://patchwork.kernel.org/patch/525891/
> 
> Looking forward, I would suggest 1 and 2 are required for stable, 3 may
> be suitable..

Problematic clusters say 3 is most excellent stable material.

	-Mike

