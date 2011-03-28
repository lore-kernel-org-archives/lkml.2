Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1C1M5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:57:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33113 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1C1M5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:57:49 -0400
Message-ID: <4D90859D.70704@zytor.com>
Date: Mon, 28 Mar 2011 05:57:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
References: <alpine.LFD.2.02.1103232321070.3848@x980> <20110325113048.GC29521@elte.hu> <alpine.LFD.2.02.1103260036300.28928@x980> <201103272340.42748.linux@rainbow-software.org>
In-Reply-To: <201103272340.42748.linux@rainbow-software.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2011 02:40 PM, Ondrej Zary wrote:
> 
> I just tested 2.6.38-rc4 on a desktop board and it works (power off at least). 
> If using Grub2, linux16 command must be used instead of linux in grub.cfg 
> (otherwise loading apm module will fail with "apm: BIOS not found").
> 

This is just Yet Another Example of the Grub2 people doing things in the
absolutely most idiotic way possible by default, and then blaming the user.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

