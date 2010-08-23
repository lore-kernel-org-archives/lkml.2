Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab0HWNr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:47:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59587 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0HWNrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cxPlBCLYKxFZa9g75LqFxoDb0d6LT+ZppBHNJUubuZ1igE2zuhpr+MLO9odaogjbqk
         lRG5SwV0jZPpVwfYBz40HqJlwHZ9u6ok8vbf0PPSsfrtDQv1+8eL4+6TQOdW/kAK0SAC
         0Hno8DcIj8wSKCq9iys3QT6LkzGFKj5KyWbeI=
MIME-Version: 1.0
In-Reply-To: <20100823030340.GA14007@suse.de>
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com>
	<4C6F4BBB.5040207@zytor.com>
	<AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com>
	<4C71CF5B.3090505@zytor.com>
	<AANLkTi=PWY=n2nvDcZM4SB7Jo2DRadRSoNYT1unfJvZ9@mail.gmail.com>
	<20100823030340.GA14007@suse.de>
Date: Mon, 23 Aug 2010 09:47:23 -0400
Message-ID: <AANLkTi=Dp90i24pm41=nM2ontGT-QJ9Ju+CJzN1mLCXv@mail.gmail.com>
Subject: Re: Linux 2.6.35.3
From: Mark Stanovich <mrktimber@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 11:03 PM, Greg KH <gregkh@suse.de> wrote:
> On Sun, Aug 22, 2010 at 09:56:19PM -0400, Mark Stanovich wrote:
>> On Sun, Aug 22, 2010 at 9:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 08/20/2010 09:06 PM, Mark Stanovich wrote:
>> >>>>
>> >>>> I noticed that the latest version pulled from Linus's git tree did not
>> >>>> have the problem. ?After looking at the changes to
>> >>>> arch/x86/include/asm/cmpxchg_32.h, I cherry-picked two patches from
>> >>>> Linus's tree that seemed to make a difference, namely:
>> >>>>
>> >>>> 69309a05907546fb686b251d4ab041c26afe1e1d
>> >>>> 4532b305e8f0c238dd73048068ff8a6dd1380291
>> >>>>
>> >>>> Applying these patches solved the rebooting problem on 2.6.35.3
>> >>>>
>> >>>> I believe the same problem also happens for the latest stable version of
>> >>>> 2.6.34, but did not verify the fix worked for the 2.6.34 stable releases.
>> >>>>
>> >>>> I don't know if this is helpful, but I thought I would let you know in
>> >>>> case someone else is having the same problem.
>> >>>>
>> >>>> If you need any further information, just let me know.
>> >>>>
>> >>>
>> >>> Yes, as a matter of fact, we have been trying to root-cause this
>> >>> problem; please see:
>> >>>
>> >>> https://bugzilla.kernel.org/show_bug.cgi?id=16612
>> >>>
>> >>> If you could try the one-liner in there and see if it solves your
>> >>> problem, it would be great.
>> >>
>> >> The patch for __set_64bit on top of 2.6.35.3 solves the rebooting problem!
>> >>
>> >>
>> >
>> > By the way, I think only 69309a05907546fb686b251d4ab041c26afe1e1d should
>> > solve the problem. ?Mark, could you try only this patch?
>> >
>>
>> Tested 69309a05907546fb686b251d4ab041c26afe1e1d on top of 2.6.35.3 and
>> this does solve the rebooting problem.
>

69309a05907546fb686b251d4ab041c26afe1e1d is also needed on top of
2.6.34.5 in order for my machine to boot properly.

    - Mark
