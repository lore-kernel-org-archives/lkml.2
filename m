Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0CXHwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:52:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:59172 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0CXHwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:52:32 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.cy
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <4BA9A8F8.5070206@kernel.org>
References: <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
	 <4BA7EE72.7000507@kernel.org>
	 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>
	 <4BA80019.5000900@kernel.org>
	 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
	 <4BA813A4.1010704@kernel.org>
	 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
	 <4BA8594F.8090205@kernel.org> <20100323080252.GA4848@elte.hu>
	 <4BA883C0.2070102@kernel.org>  <20100323094834.GB4576@elte.hu>
	 <1269404982.8599.148.camel@pasglop> <1269405882.8599.155.camel@pasglop>
	 <4BA9A8F8.5070206@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 18:43:57 +1100
Message-ID: <1269416637.8599.183.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 22:54 -0700, Yinghai Lu wrote:
> if the array can be doubled and have old one copied to new one. 
> then we don't change lmb.c too much.
> 
> new early_res.c exend lmb. and another half already works with x86 to
> replace bootmem.
> 
> will check if i can produce one patch to make powerpc to reuse
> early_res/nobootmem

While at it, can you rename early_res to something that doesn't
suck ? :-)

Cheers,
Ben.


