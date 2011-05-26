Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1EZM0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:26:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492Ab1EZM0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:26:41 -0400
Date: Thu, 26 May 2011 14:26:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
Message-ID: <20110526122623.GA11875@elte.hu>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
 <1306272750.2497.79.camel@laptop>
 <1306343335.21578.65.camel@twins>
 <1306358128.21578.107.camel@twins>
 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
 <1306405979.1200.63.camel@twins>
 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
 <1306409575.1200.71.camel@twins>
 <1306412511.1200.90.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306412511.1200.90.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Sort this by reverting to the old behaviour for this situation and 
> perform a full remote wake-up.

Btw., ARM should consider switching most of its subarchitectures to 
!__ARCH_WANT_INTERRUPTS_ON_CTXSW - enabling irqs during context 
switches is silly and now expensive as well.

Thanks,

	Ingo
