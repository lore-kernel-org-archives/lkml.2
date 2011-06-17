Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1FQIUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:20:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab1FQIUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:20:20 -0400
Date: Fri, 17 Jun 2011 10:19:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Milton Miller <miltonm@bga.com>, Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, WANG Cong <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] generic-ipi: Initialize call_single_queue before
 enabling interrupt
Message-ID: <20110617081911.GB893@elte.hu>
References: <D6CBEE2F420741indou.takao@jp.fujitsu.com>
 <ABCC2C38C9CAC4indou.takao@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ABCC2C38C9CAC4indou.takao@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takao Indoh <indou.takao@jp.fujitsu.com> wrote:

> Just a reminder...
> 
> Thanks for acks, but I'm still waiting for inclusion.
> I tested 3.0.0-rc3 and kdump still failed due to pending IPI
> from 1st kernel. Need this patch to fix it.

For any future patch that has a review discussion (like this one) 
please collect Acks and resend the patch with the acks included once 
the discussion results in a final patch, otherwise maintainers might 
skip the patch as "still being reviewed".

I've collected the acks here and started testing your patch.

Thanks,

	Ingo
