Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1BQRX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:23:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1BQRX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:23:27 -0500
Date: Thu, 17 Feb 2011 18:23:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tony.luck@intel.com, tglx@linutronix.de, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 3/3] ia64: drop custom exception table implementation
Message-ID: <20110217172321.GC17058@elte.hu>
References: <4D5D631F0200007800032802@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5D631F0200007800032802@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> Now that the common extable implementation can deal with the needs
> ia64 has, drop its custom implementation.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/ia64/Kconfig               |    1 
>  arch/ia64/include/asm/uaccess.h |    9 ---
>  arch/ia64/mm/extable.c          |   98 ----------------------------------------
>  3 files changed, 4 insertions(+), 104 deletions(-)

Nice generalization of the exception code.

If Tony acks this patch then we can put the 3 patches into a separate -tip branch 
and test it on x86 and push it into -next for ia64 testing. That would be the 
simplest upstream merge route - if that's fine by Tony as well.

Thanks,

	Ingo
