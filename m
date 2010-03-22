Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0CVVxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:53:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:47023 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab0CVVxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:53:16 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20100322212013.GB25254@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
	 <20100321.210023.209981130.davem@davemloft.net>
	 <4BA6F1F6.3070102@kernel.org>
	 <20100321.213350.176660494.davem@davemloft.net>
	 <20100322092809.GA20607@elte.hu>
	 <20100322113026.GA11526@brick.ozlabs.ibm.com>
	 <20100322130530.GC12475@elte.hu> <1269291846.8599.81.camel@pasglop>
	 <20100322212013.GB25254@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 08:52:49 +1100
Message-ID: <1269294769.8599.88.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 22:20 +0100, Ingo Molnar wrote:
> 
> So no arguments from me at all about the code quality aspects - i just wanted 
> to highlight the huge amount of non-trivial work Yinghai has invested into 
> this already, with little external help, and that if possible it would be nice 
> to minimize the upsetting of related x86 code if possible. Please help him out 
> with more specific suggestions about how the two memory allocation spaces 
> could be unified best, to serve the needs of all these architectures - if you 
> have some spare time. 

Why not start by unifying the APIs to it, while keeping the
implementation in the arch for now ? That would be a good first step and
would give us a good idea of what kind of requirements all the archs
have since to some extent those requirements need to be represented in
this API.

Cheers,
Ben.


