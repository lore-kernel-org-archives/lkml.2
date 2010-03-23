Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0CWBhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:37:08 -0400
Received: from www.tglx.de ([62.245.132.106]:34684 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab0CWBhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:37:06 -0400
Date: Tue, 23 Mar 2010 02:36:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
In-Reply-To: <4BA813A4.1010704@kernel.org>
Message-ID: <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> <4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> <20100322092809.GA20607@elte.hu> <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain>
 <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org> <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain> <4BA7EE72.7000507@kernel.org> <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain> <4BA80019.5000900@kernel.org>
 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain> <4BA813A4.1010704@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,

On Mon, 22 Mar 2010, Yinghai Lu wrote:

> On 03/22/2010 05:45 PM, Thomas Gleixner wrote:
> > B1;2005;0cYinghai,
> >>
> >> to make x86 to use lmb, we need to extend lmb to have find_early_area.
> > 
> > Why ?
> 
> unless you want to dump two users of find_e820_area_size()

I don't care about the two users of find_e820_area_size() as long as
you are not willing to spend more than a split second to explain
things.

I'm really fed up to pull answers from your nose bit by bit. Me and
others wrote lengthy explanations and asked precise questions. 

All we get are some meager bones thrown our way.

If that's your understanding of community work, fine. It's just not
our way of working together. After spending valuable time on that I
completely agree with Dave on:

 "Now I know that you _REALLY_ aren't listening to us."

It's not only that you are not listening, you are simply ignoring our
concerns. Go ahead with that, but do not wonder about us ignoring you
as well.

Thanks,

	tglx

