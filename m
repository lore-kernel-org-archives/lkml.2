Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1C1FpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:45:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47207 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab1C1FpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:45:16 -0400
Message-ID: <4D90201D.1010308@zytor.com>
Date: Sun, 27 Mar 2011 22:43:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ondrej Zary <linux@rainbow-software.org>, Len Brown <lenb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
References: <alpine.LFD.2.02.1103232321070.3848@x980> <20110325113048.GC29521@elte.hu> <alpine.LFD.2.02.1103260036300.28928@x980> <201103272340.42748.linux@rainbow-software.org> <20110328045108.GA26322@elte.hu>
In-Reply-To: <20110328045108.GA26322@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2011 09:51 PM, Ingo Molnar wrote:
> 
> * Ondrej Zary <linux@rainbow-software.org> wrote:
> 
>>> Is there somebody on LKML that has a older laptop than me
>>> and is able to get it to boot in APM mode?  I'd be astonished
>>> if there was not.  Are they willing to regularly test changes
>>> to the upstream kernel to make sure that APM still works?
>>> If yes, where have they been for the last 5 years?
>>
>> I just tested 2.6.38-rc4 on a desktop board and it works (power off at least). 
> 
> Ok, thanks for testing. I too tried APM poweroff in the not too distant past 
> and it worked - but not very recent kernels.
> 

Given that the current merge window rewrote this code, it would be good
to get it tested on 2.6.39-rc1 when it becomes available.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

