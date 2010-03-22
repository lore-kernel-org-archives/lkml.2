Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0CVUsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:48:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:34317 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab0CVUsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:48:17 -0400
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
Date: Tue, 23 Mar 2010 07:47:42 +1100
Message-ID: <1269290862.8599.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 10:28 +0100, Ingo Molnar wrote:
> Note the other side of the coin: LMB appears to be deployed on only 4
> non-x86 
> architectures that muster ~1% of the Linux boxes while early_res is
> deployed 
> on more than 95%. 

You use that arguemnt ONE MORE FUCKING TIME and you'll end up in my
killfile with a auto-NACK reply of anything that looks like a patch from
you.

Ben.


