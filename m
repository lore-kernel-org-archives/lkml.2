Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0C2QWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:22:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:52141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0C2QWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:22:48 -0400
Message-ID: <4BB0D34C.7060509@kernel.org>
Date: Mon, 29 Mar 2010 09:20:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 20/31] lmb: Add __NOT_KEEP_LMB to put lmb code to .init
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269830604-26214-21-git-send-email-yinghai@kernel.org> <1269864470.24620.15.camel@concordia>
In-Reply-To: <1269864470.24620.15.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 05:07 AM, Michael Ellerman wrote:
> On Sun, 2010-03-28 at 19:43 -0700, Yinghai Lu wrote:
>> So those lmb bits could released after kernel is booted up.
>>
>> Arch code could define __NOT_KEEP_LMB in asm/lmb.h, __init_lmb will become __init
> 
> ARCH_KEEP_LMB or ARCH_DISCARD_LMB, or something like that, would be more
> in keeping with existing flags like this.
> 

ok, will use ARCH_DISCARD_LMB.

BTW, it seems only PowerPC need to keep lmb after init stage, right ?

Thanks

Yinghai
