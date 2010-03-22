Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0CVVyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:54:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:47046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab0CVVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:54:38 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20100322205703.GA25254@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
	 <20100321.210023.209981130.davem@davemloft.net>
	 <4BA6F1F6.3070102@kernel.org>
	 <20100321.213350.176660494.davem@davemloft.net>
	 <20100322092809.GA20607@elte.hu> <1269290862.8599.77.camel@pasglop>
	 <20100322205703.GA25254@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 08:54:17 +1100
Message-ID: <1269294857.8599.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 21:57 +0100, Ingo Molnar wrote:
> 
> > You use that arguemnt ONE MORE FUCKING TIME and you'll end up in my killfile 
> > with a auto-NACK reply of anything that looks like a patch from you.
> 
> Does this mean you disagree with that? (I think it's pretty factual, last i 
> checked the usage stats of devel kernels was somewhere around 99.7%.)

I disagree with that being a relevant argument in the technical
discussion on the relative merits of two implementations of a given
facility. I also disagree with your numbers, if you talk about
deployement, I would be very very surprised if ARM wasn't close to
on-par with x86.

> In any case, i dont dispute that LMB is a bit cleaner than kernel/early_res.c 
> - and both are much cleaner than the new e820 kernel/fw_memmap.c code posted 
> here by Yinghai.
> 
> If you dont disagree then please spare me the insults. (or move me into your 
> killfile) 

Well, I find some of your arguments quite insulting too, but let's move
on.

Cheers,
Ben.


