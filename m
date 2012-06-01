Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2FAJuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:50:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57170 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab2FAJt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <4FC810B3.5040208@candelatech.com>
References: <4FC6B85C.20201@candelatech.com>
	<4FC6E257.4070608@candelatech.com>
	<23353.1338510488@turing-police.cc.vt.edu>
	<4FC810B3.5040208@candelatech.com>
Date: Fri, 1 Jun 2012 05:49:57 -0400
Message-ID: <CAANzHtSHRXkYJcBRBvCRPj_KR-q3qSUa6xNNmFDLHB-ixDMv9w@mail.gmail.com>
Subject: Re: Anyone successfully booted a custom kernel on Fedora 17?
From: =?UTF-8?B?wqA=?= <porpen@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: valdis.kletnieks@vt.edu,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 31 May 2012 20:45, Ben Greear <greearb@candelatech.com> wrote:
> On 05/31/2012 05:28 PM, valdis.kletnieks@vt.edu wrote:
>>
>> On Wed, 30 May 2012 20:15:35 -0700, Ben Greear said:
>>>
>>> On 05/30/2012 05:16 PM, Ben Greear wrote:
>>>>
>>>> This is probably a Fedora 17 issue..but hoping someone will have mercy
>>>> on me :)
>>>
>>>
>>> Must be something to do with my kernel config or how I generate
>>> the initrd with mkinitrd:
>>
>>
>> For what it's worth, over on the Rawhide side of the fence, dracut-018-74
>> builds bad initramfs images for me,while dracut-081-53 works.  Not sure
>> what release is in the F17 updates repository.  I'm going to file a bug
>> report
>> with Fedora soon as I figure out what -74 is doing wrong.
>
>
> At least my problem appears to be some missing feature in the kernel,
> probably
> one of the 'fooFS' things releated to ramdisk and/or early startup.
> I enabled several things I found in the F17 .config file that were not in my
> config file, and now my kernel boots, at least when I
> build and install it on the F17 machine.
>
> I'm going to try building on F13 and just (re)making the initrd on
> F17 like I have been for all other distributions, but that will be
> a day or two..got a release to shove out the door first!
>
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This thread might help you folks.
http://lkml.org/lkml/2012/5/18/230
Urgent: x86-32 and GNU ld 2.22.52.0.1

Happy bug hunting
-p
