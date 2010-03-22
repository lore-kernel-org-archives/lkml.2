Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0CVVBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:01:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:53938 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0CVVBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:01:47 -0400
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
In-Reply-To: <20100322092809.GA20607@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
	 <20100321.210023.209981130.davem@davemloft.net>
	 <4BA6F1F6.3070102@kernel.org>
	 <20100321.213350.176660494.davem@davemloft.net>
	 <20100322092809.GA20607@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 08:01:23 +1100
Message-ID: <1269291683.8599.79.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 10:28 +0100, Ingo Molnar wrote:
> Those early_res patches were posted all over on lkml, it was literally 
> hundreds of difficult patches, and now, months down the line, after we've 
> tested and upstreamed it (with many nasty regressions fixed on x86 during the 
> development of it) you come with a rigid "do it some other way, convert all of 
> x86 over again or else" position.

There's an easy solution here. Leave that gunk in arch/x86 where it
belongs and if you want to unify things a bit, then do it at the -API-
level only, and leave the implementation where it is.

> I really wish non-x86 architectures apprecitated (and helped) the core kernel 
> work x86 is doing, because it is subsidizing non-x86 architectures all the 
> time. 

I'm not even going to bother replying to that one

Ben.



