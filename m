Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab0GFEQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 00:16:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46934 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0GFEQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 00:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QLWGsJjfGFw4Lj2BoQd6PlbzdeswxrCNiw2O1KVV2yVuBx+hI/8ICgQwldJwr4cSx8
         GNahO6ae2BFMtwv/f/xYKp5KW67EfDyvCnSyqIBHZXn/J3lkX4toxdNedZ3IEDabj9Kk
         Xv0m05kqFXblqmCtb3MThF3CEVwlH09Vhuxfw=
MIME-Version: 1.0
In-Reply-To: <4C3271FF.9080308@gmail.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C2F5ECB.1040505@kernel.org>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F87C1.8000701@hardwarefreak.com>
	<AANLkTimVJEO-yF3GZ2ghX6DNPuAu-A-MNNO9x8Q1EpRc@mail.gmail.com>
	<4C2F9292.708@hardwarefreak.com>
	<AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com>
	<AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>
	<4C31796C.8050209@kernel.org>
	<AANLkTinvNGha7SfaAWYIjUJwR9ZelCbHAWK0qvvllF9S@mail.gmail.com>
	<4C3271FF.9080308@gmail.com>
Date: Mon, 5 Jul 2010 21:16:15 -0700
Message-ID: <AANLkTilAvJUthkXM7KL9BhLwEv9kJn31Rs8wDTAe4PlY@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Stan Hoeppner <stan@hardwarefreak.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 5, 2010 at 4:59 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 07/05/2010 10:48 AM, Mark Knecht wrote:
>>
>> On Sun, Jul 4, 2010 at 11:19 PM, Tejun Heo<tj@kernel.org>  wrote:
>>>
>>> Hello,
>>>
>>> On 07/04/2010 12:31 AM, Mark Knecht wrote:
>>>>
>>>> OK, I don't know if this is related but so far I cannot get the
>>>> machine to boot if I set BIOS SATA configuration to AHCI. I believe
>>>> that I have AHCI support as well as SATA support built into the kernel
>>>> but when I set the BIOS to AHCI the machine just hangs saying it finds
>>>> no medium. I assume that means no hard drive. I have to set SATA
>>>> support to enhanced and then IDE to get the machine to boot at all.
>>>
>>> That's odd.  Can you please attach kernel boot log w/ ahci mode?
>>> Booting a recent live CD and saving boot log from there should do the
>>> trick.
>>>
>>> Thanks.
>>>
>>> --
>>> tejun
>>>
>>
>> Hi Tehun,
>>    Thanks for the help.
>>
>>    I tried a Gentoo install CD from last march. It's a 2.6.31 type
>> kernel. Problem is the buffer depths are not big enough to capture the
>> complete dmesg contents and I don't know a command line option to make
>> it larger on the fly. If you know of one that's got a larger buffer -
>> or a command to increase it at boot time - then let me know and I'll
>> try again.
>>
>>    I'm attaching what I was able to catch for both AHCI and IDE
>> settings in BIOS for the storage configuration option.
>>
>>    It seems to me that even in AHCI mode the machine does see all the
>> hard drives. Maybe there's something about my boot partition that's
>> having problems in AHCI mode only? If it sees /dev/sda then why
>> wouldn't it find grub and at least show a grub menu?
>
> On some machines changing from IDE to AHCI messes up the boot order
> selection in the BIOS - you may have to switch to AHCI, save settings,
> reboot, go back into the BIOS and then make sure the disk boot order
> settings are correct (whatever drive grub is installed on needs to be
> first).
>

That's a very interesting idea Robert. Thanks.

I'll have to be careful. I have 5 identical drives in the machine so
figuring out which is which when I'm in BIOS might be a bit of a
trick.

I'll give it a go and report back.

Cheers,
Mark
