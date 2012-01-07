Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2AGMle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 07:41:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60731 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab2AGMld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 07:41:33 -0500
References: <20120105152918.GA12838@elte.hu> <20120106230526.088cb77546022ecda34aaae5@canb.auug.org.au> <4F077FA8.7060100@zytor.com> <20120107123347.GA18966@elte.hu>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120107123347.GA18966@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] x86/syscall changes for v3.3
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Sat, 07 Jan 2012 04:41:02 -0800
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <9fd64870-c357-493e-ae70-1aa022ceca51@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll dig up and push the fix in the morning.

Ingo Molnar <mingo@elte.hu> wrote:

>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> 
>> On 01/06/2012 04:05 AM, Stephen Rothwell wrote:
>> > 
>> > HPA has a pending fix for this patch as it causes warnings on
>> > PowerPC at least.  The idea was to move this include of
>> > asm/asm-offsets.h into asm/ftrace.h so it only affects x86.
>> > 
>> 
>> Sorry... have been in baby mode for the past week, but yes, I 
>> think it only causes warnings and it's a trivial fix.
>
>Lets delay this tree nevertheless, the warnings seem numerous 
>and annoying (and they've been reported), right?
>
>Linus, please don't pull it for now.
>
>Thanks,
>
>	Ingo

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
