Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab0CXEuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:50:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:48800 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab0CXEue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:50:34 -0400
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
In-Reply-To: <20100323111612.GB1189@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
	 <20100321.210023.209981130.davem@davemloft.net>
	 <4BA6F1F6.3070102@kernel.org>
	 <20100321.213350.176660494.davem@davemloft.net>
	 <20100322092809.GA20607@elte.hu> <1269290862.8599.77.camel@pasglop>
	 <20100322205703.GA25254@elte.hu> <1269294857.8599.90.camel@pasglop>
	 <20100323111612.GB1189@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 15:50:00 +1100
Message-ID: <1269406200.8599.159.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 12:16 +0100, Ingo Molnar wrote:
> 
> So if you want your architecture to matter to me the rule is very simple: 
> contribute, contribute, contribute, and stop whining. If you dont contribute, 
> frankly you dont really exist to me. On the other hand if you are actively 
> contributing while your architecture only exists on paper, it already starts 
> mattering to me.
> 
> I'm really that simple.

So basically, what you are saying is that, totally regardless of how
much an architecture is actually used in the field, if the architecture
maintainer for it doesn't also do your work and contribute to every
single of your pet projects, or if everybody is like you, every single
other subsystem in the kernel, then that architecture is irrelevant for
technical considerations and choices regarding any design decision made
to the core kernel ?

Sorry Ingo, but that's just arrogant bullshit. So stop trying to win
this useless argument, all you manage to do is anger people and make us
even less willing to actually work with you.

Cheers,
Ben.


