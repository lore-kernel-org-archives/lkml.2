Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1KKHOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 02:14:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1KKHOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 02:14:10 -0500
Date: Fri, 11 Nov 2011 08:12:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Chen Jie <chenj@lemote.com>,
        zhangfx <zhangfx@lemote.com>
Subject: Re: [GIT PULL] clocksource:  Avoid possible mult overflows
Message-ID: <20111111071225.GB14347@elte.hu>
References: <1320953625.10668.86.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320953625.10668.86.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> Hey Ingo,
> 	Here's the revised fix to the mult overflow issue against
> tip/timers/core. Let me know if you hit any other issues.
> 
> thanks
> -john
> 
> 
>   git://git.linaro.org/people/jstultz/linux.git formingo/3.2/tip/timers/core

Pulled, thanks John!

Note, it was not based on the latest tip:timers/core branch of:

    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

and it conflicted with another patch of yours (trivially). I've 
resolved the conflict, please double check that it's all fine.

Thanks,

	Ingo
