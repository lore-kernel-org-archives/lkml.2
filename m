Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0HWB4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:56:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45652 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0HWB4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=As024MQUgRLcGbBX8W3lE8z8kCfndxqKTkHWL+th9psKgiqTruhZOSDnuXPenz4eAz
         FkNWtRZVM1qUGe1Y/mzByaovBjxj5X7wso91vctmfOi4nA88RD/znRwO+nPDjb6zQEw3
         EFv/KmnYf7EpAQrOtMmp9bn8w1fibUUfmsPO4=
MIME-Version: 1.0
In-Reply-To: <4C71CF5B.3090505@zytor.com>
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com>
	<4C6F4BBB.5040207@zytor.com>
	<AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com>
	<4C71CF5B.3090505@zytor.com>
Date: Sun, 22 Aug 2010 21:56:19 -0400
Message-ID: <AANLkTi=PWY=n2nvDcZM4SB7Jo2DRadRSoNYT1unfJvZ9@mail.gmail.com>
Subject: Re: Linux 2.6.35.3
From: Mark Stanovich <mrktimber@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 9:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/20/2010 09:06 PM, Mark Stanovich wrote:
>>>>
>>>> I noticed that the latest version pulled from Linus's git tree did not
>>>> have the problem.  After looking at the changes to
>>>> arch/x86/include/asm/cmpxchg_32.h, I cherry-picked two patches from
>>>> Linus's tree that seemed to make a difference, namely:
>>>>
>>>> 69309a05907546fb686b251d4ab041c26afe1e1d
>>>> 4532b305e8f0c238dd73048068ff8a6dd1380291
>>>>
>>>> Applying these patches solved the rebooting problem on 2.6.35.3
>>>>
>>>> I believe the same problem also happens for the latest stable version of
>>>> 2.6.34, but did not verify the fix worked for the 2.6.34 stable releases.
>>>>
>>>> I don't know if this is helpful, but I thought I would let you know in
>>>> case someone else is having the same problem.
>>>>
>>>> If you need any further information, just let me know.
>>>>
>>>
>>> Yes, as a matter of fact, we have been trying to root-cause this
>>> problem; please see:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=16612
>>>
>>> If you could try the one-liner in there and see if it solves your
>>> problem, it would be great.
>>
>> The patch for __set_64bit on top of 2.6.35.3 solves the rebooting problem!
>>
>>
>
> By the way, I think only 69309a05907546fb686b251d4ab041c26afe1e1d should
> solve the problem.  Mark, could you try only this patch?
>

Tested 69309a05907546fb686b251d4ab041c26afe1e1d on top of 2.6.35.3 and
this does solve the rebooting problem.

    - Mark
