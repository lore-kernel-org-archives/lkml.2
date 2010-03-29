Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0C2RBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:01:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:41520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0C2RBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:01:39 -0400
Message-ID: <4BB0DC5E.1040404@kernel.org>
Date: Mon, 29 Mar 2010 09:59:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/31] x86: Make sure free_init_pages() free pages in
 boundary
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org> <1269830604-26214-3-git-send-email-yinghai@kernel.org> <20100329165706.GA13961@elte.hu>
In-Reply-To: <20100329165706.GA13961@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 09:57 AM, Ingo Molnar wrote:
> 
> Note, i applied the fix below, without it the 32-bit defconfig build would 
> fail with:
> 
>  arch/x86/kernel/head32.c: In function 'i386_start_kernel':
>  arch/x86/kernel/head32.c:50: error: implicit declaration of function 'PAGE_ALIGN'
> 
thanks.

after lmb work, will check all those
round_up
round_down
roundup
PAGE_ALIGN
ALIGN
...

We promised to Andrew, We need to clean them up.


Yinghai
