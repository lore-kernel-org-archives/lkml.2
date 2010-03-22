Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0CVU5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:57:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab0CVU5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:57:32 -0400
Date: Mon, 22 Mar 2010 21:57:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
Message-ID: <20100322205703.GA25254@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
 <20100322092809.GA20607@elte.hu>
 <1269290862.8599.77.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269290862.8599.77.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2010-03-22 at 10:28 +0100, Ingo Molnar wrote:

> > Note the other side of the coin: LMB appears to be deployed on only 4 
> > non-x86 architectures that muster ~1% of the Linux boxes while early_res 
> > is deployed on more than 95%.
> 
> You use that arguemnt ONE MORE FUCKING TIME and you'll end up in my killfile 
> with a auto-NACK reply of anything that looks like a patch from you.

Does this mean you disagree with that? (I think it's pretty factual, last i 
checked the usage stats of devel kernels was somewhere around 99.7%.)

In any case, i dont dispute that LMB is a bit cleaner than kernel/early_res.c 
- and both are much cleaner than the new e820 kernel/fw_memmap.c code posted 
here by Yinghai.

If you dont disagree then please spare me the insults. (or move me into your 
killfile)

Thanks,

	Ingo
