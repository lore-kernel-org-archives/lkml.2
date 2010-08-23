Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0HWBbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:31:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44945 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0HWBbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:31:47 -0400
Message-ID: <4C71CF5B.3090505@zytor.com>
Date: Sun, 22 Aug 2010 18:31:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Mark Stanovich <mrktimber@gmail.com>
CC: torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.3
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com>	<4C6F4BBB.5040207@zytor.com> <AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com>
In-Reply-To: <AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 09:06 PM, Mark Stanovich wrote:
>>>
>>> I noticed that the latest version pulled from Linus's git tree did not
>>> have the problem.  After looking at the changes to
>>> arch/x86/include/asm/cmpxchg_32.h, I cherry-picked two patches from
>>> Linus's tree that seemed to make a difference, namely:
>>>
>>> 69309a05907546fb686b251d4ab041c26afe1e1d
>>> 4532b305e8f0c238dd73048068ff8a6dd1380291
>>>
>>> Applying these patches solved the rebooting problem on 2.6.35.3
>>>
>>> I believe the same problem also happens for the latest stable version of
>>> 2.6.34, but did not verify the fix worked for the 2.6.34 stable releases.
>>>
>>> I don't know if this is helpful, but I thought I would let you know in
>>> case someone else is having the same problem.
>>>
>>> If you need any further information, just let me know.
>>>
>>
>> Yes, as a matter of fact, we have been trying to root-cause this
>> problem; please see:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=16612
>>
>> If you could try the one-liner in there and see if it solves your
>> problem, it would be great.
> 
> The patch for __set_64bit on top of 2.6.35.3 solves the rebooting problem!
> 
> 

By the way, I think only 69309a05907546fb686b251d4ab041c26afe1e1d should
solve the problem.  Mark, could you try only this patch?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

