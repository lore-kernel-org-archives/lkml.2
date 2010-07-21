Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab0GUVW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:22:56 -0400
Received: from d72-38-7-254.commercial1.cgocable.net ([72.38.7.254]:1562 "EHLO
	max" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755657Ab0GUVWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:22:55 -0400
Message-ID: <13ec35777817500abfcc6c8da0224351.squirrel@thechecks.ca>
In-Reply-To: <AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
    <4C2F5ECB.1040505@kernel.org>
    <AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
    <4C2F61AB.9030806@kernel.org>
    <AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
    <4C317C04.20500@kernel.org>
    <AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
    <4C32CE50.6010501@kernel.org>
    <AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>
    <4C341598.6040004@kernel.org>
    <AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
    <4C34A1D5.1090202@kernel.org>
    <AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>
    <4C34B8BE.5080504@kernel.org>
    <AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
    <4C44BD42.3030904@kernel.org>
    <7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
    <4C45AF40.7030800@kernel.org>
    <AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
Date: Wed, 21 Jul 2010 17:22:51 -0400
From: "Paul Check" <paul@thechecks.ca>
To: "Mark Knecht" <markknecht@gmail.com>
Cc: "Tejun Heo" <tj@kernel.org>,
        "Linux Kernel List" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
X-Priority: 3 (Normal)
Importance: Normal
X-SA-Exim-Connect-IP: 72.38.7.254
X-SA-Exim-Mail-From: paul@thechecks.ca
Subject: Re: Drives missing at boot
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on max)
X-bounce-key: openstreet.com-1;paul@thechecks.ca;1279747375;49b51fee;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's unfortunate. FYI I have continued to be trouble free, but my
processor is a bit weaker than Mark's, although I would find it surprising
that this would cause a problem.  Also, FYI Mark, I have 12GB of Corsair
RAM, and have it bumped up to the Intel XMP profile.

P

> On Tue, Jul 20, 2010 at 7:14 AM, Tejun Heo <tj@kernel.org> wrote:
>> Helo,
>>
>> On 07/20/2010 05:14 AM, Paul Check wrote:
>>> Hey Tejun: I guess this is the same patch that you sent me to fix my
>>> issue
>>> with missing drives.  Good news: I've been through about 10 reboots
>>> now
>>> and no problems.  Based on my prior experience, I'd say with the old
>>> setup, 10 clean boots in a row was probably less than a 1% event.  So,
>>> it
>>> seems that this has fixed my problem.
>>
>> Yeap, it's the same one.  I'm forwarding the patch upstream now but,
>> Mark, please let me know the test result.
>>
>> Thanks.
>>
>> --
>> tejun
>>
>
> Tejun,
>    Looks like I had a failure today. First one in weeks and only the
> 3rd or 4th boot with this newer patch file. One of the two drives
> making a RAID0 wasn't found so /dev/md11 (constructed from /dev/sdd
> and /dev/sde) couldn't be started. I did a cold reboot and the drive
> was found.
>
>    If it matters, and it probably doesn't, the failure came on a boot
> which had a scheduled fsck to do of /dev/md5 - my main / drive. I
> don't see how that would make a difference but I figure why leave the
> info out. That's why the times are so much larger in the dmesg file.
> (I think)
>
>    dmesg attached. I patched the Gentoo kernel if it makes a
> difference, same as I did with the earlier patch.
>
> mark@c2stable ~ $ uname -a
> Linux c2stable 2.6.34-gentoo-r2 #1 SMP PREEMPT Sun Jul 18 14:09:48 PDT
> 2010 x86_64 Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz GenuineIntel
> GNU/Linux
> mark@c2stable ~ $
>
> Sorry,
> Mark
>


