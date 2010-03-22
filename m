Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0CVVJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:09:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:38706 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab0CVVJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:09:16 -0400
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
In-Reply-To: <4BA7CE1B.9070109@kernel.org>
References: <4BA6EA62.1030603@kernel.org>
	 <20100321.210023.209981130.davem@davemloft.net>
	 <4BA6F1F6.3070102@kernel.org>
	 <20100321.213350.176660494.davem@davemloft.net>
	 <20100322092809.GA20607@elte.hu>
	 <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain>
	 <20100322193720.GA2844@elte.hu>  <4BA7CE1B.9070109@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 08:08:26 +1100
Message-ID: <1269292106.8599.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 13:07 -0700, Yinghai Lu wrote:
> 1. need to keep e820
> 2. use e820 range with RAM to fill lmb.memory when finizing_e820
> 3. use lmb.reserved to replace early_res.
> 
> current lmb is merging the region, we can not use name tag any more.

Feel free to extend LMB as long as it's reasonable. For example, I
wouldn't object to have flags or similar things to LMB regions, one of
them being used to prevent merge for example.

> may need to dump early_memtest, and use early_res for bootmem at
> first. 

Cheers,
Ben.


