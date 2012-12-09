Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2LIBPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 20:15:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64571 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2LIBPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 20:15:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121208194613.GC3897@kroah.com>
References: <20121207005232.756641002@linuxfoundation.org>
	<CAKocOOM-QZ88+sV40C8OJWAN89W4QkDKx+gLjrmZEeUs=CJ57g@mail.gmail.com>
	<CAKocOOOKAeD=BuRnDa6U7KtHOXAK7b-VCibQohPGkAB-ZYX4aA@mail.gmail.com>
	<CAKocOOO8bJ+vBuG3Dwx_-EnAqcVJ00G69Rc764eFTuhgszJntQ@mail.gmail.com>
	<20121208194613.GC3897@kroah.com>
Date: Sat, 8 Dec 2012 18:15:52 -0700
Message-ID: <CAKocOOMLzEzMPOTghQhQJ=pyV0spvWe3qcUM3g5VtT=k69wF9g@mail.gmail.com>
Subject: Re: [ 00/20] 3.4.23-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 12:46 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Dec 07, 2012 at 05:59:24PM -0700, Shuah Khan wrote:
>> On Fri, Dec 7, 2012 at 5:52 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> > On Fri, Dec 7, 2012 at 5:49 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> >> On Thu, Dec 6, 2012 at 5:54 PM, Greg Kroah-Hartman
>> >> <gregkh@linuxfoundation.org> wrote:
>> >>> This is the start of the stable review cycle for the 3.4.23 release.
>> >>> There are 20 patches in this series, all will be posted as a response
>> >>> to this one.  If anyone has any issues with these being applied, please
>> >>> let me know.
>> >>>
>> >>> Responses should be made by Sun Dec  9 00:50:03 UTC 2012.
>> >>> Anything received after that time might be too late.
>> >>>
>> >>> The whole patch series can be found in one patch at:
>> >>>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.23-rc1.gz
>> >>> and the diffstat can be found below.
>> >>>
>> >>> thanks,
>> >>>
>> >>> greg k-h
>> >>
>> >> Patche applied cleanly and compiled and booted on the following systems:
>> >>
>> >> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
>> >> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>> >>
>> >> Cross-compile tests
>> >> alpha: defconfig passed
>> >> arm: defconfig passed
>> >> c6x: defconfig passed
>> >> mips: defconfig passed
>> >> mipsel: defconfig passed
>> >> powerpc: wii_defconfig passed
>> >> sh: defconfig passed
>> >> sparc: defconfig passed
>> >> tile: tilegx_defconfig passed
>> >
>> > Correction.
>> > tile: tilegx_defconfig failed:
>> >
>> > tile tilegx_defconfig
>> >
>> > Just a snippet, I can send a full log.
>> >
>> >  LD      init/built-in.o
>> >   HOSTCC  usr/gen_init_cpio
>> >   /home/shuah/lkml/linux_stable_testing_3.0.56/scripts/gen_initramfs_list.sh:
>> > Cannot open 'usr/contents.txt'
>> > make[1]: *** [usr/initramfs_data.cpio] Error 1
>> > make: *** [usr] Error 2
>> >
>> > Didn't get a chance to investigate.
>>
>> Sorry tile failure is for 3.0.56
>
> Is that caused by something new in 3.0.56, or has it always been that
> way?

Sorry forgot to mention that it is not a regression in 3.0.56. I
compared the patch
and this source file is not patched in 3.0.56-rc1. git log shows that
this file was last
touched back in Jan of 2011 and very likely this error was introduced
in a commit from
Sept 2010.

You can choose to leave this in and I sent a patch which can go
through its normal process
and get pulled in when it gets approved by the powerpc maintainers.

-- Shuah
