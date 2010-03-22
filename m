Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0CVV5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:57:21 -0400
Received: from ozlabs.org ([203.10.76.45]:51142 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab0CVV5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:57:19 -0400
Date: Tue, 23 Mar 2010 08:57:10 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.c
Message-ID: <20100322215710.GB11526@brick.ozlabs.ibm.com>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
 <20100322092809.GA20607@elte.hu>
 <1269290862.8599.77.camel@pasglop>
 <20100322205703.GA25254@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322205703.GA25254@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 09:57:03PM +0100, Ingo Molnar wrote:

> Does this mean you disagree with that? (I think it's pretty factual, last i 
> checked the usage stats of devel kernels was somewhere around 99.7%.)

Is that number obtained from Fedora downloads or something?  I
wouldn't be surprised if desktop usage of bleeding-edge kernels is
near 100%, since basically all desktop machines are x86 these days.
I think that number would be biased against server and embedded
machines, but without knowing exactly what you're counting it's hard
to say.

In any case, I don't think the number of machines is particularly
relevant.  Linux runs on maybe 1% of all desktop machines in the
world, according to numbers I've seen, but that doesn't make it
irrelevant or not worth working on.

Paul.
