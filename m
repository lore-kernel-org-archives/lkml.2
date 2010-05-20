Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0ETDnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:43:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:43585 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab0ETDnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:43:04 -0400
Date: Thu, 20 May 2010 12:38:01 +0900
To: davem@davemloft.net
Cc: mpm@selenic.com, geert@linux-m68k.org, dwmw2@infradead.org,
       herbert@gondor.hengli.com.au, penberg@cs.helsinki.fi, ken@codelabs.ch,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100519.123325.123438307.davem@davemloft.net>
References: <AANLkTikZyfxBjXdvNzuVT2N9XIyJmY6JDiKRMRtAykeC@mail.gmail.com>
	<1274278307.11603.1264.camel@calx>
	<20100519.123325.123438307.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100520124026G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 20 May 2010 12:38:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 12:33:25 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Matt Mackall <mpm@selenic.com>
> Date: Wed, 19 May 2010 09:11:47 -0500
> 
> > I still think we should add it to all of them as positive documentation
> > that this issue has been considered. And then make the kernel not
> > compile without it so new arch implementors can't miss it.
> 
> I agree and would even go so far as to suggest that we break all
> architectures not setting it now.

About documentation, I think that ARCH_KMALLOC_MINALIGN description
would fit in "Platform Issues" section in DMA-API-HOWTO. I'll add it
later.
