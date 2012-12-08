Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2LHAwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:52:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42907 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2LHAwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:52:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOM-QZ88+sV40C8OJWAN89W4QkDKx+gLjrmZEeUs=CJ57g@mail.gmail.com>
References: <20121207005232.756641002@linuxfoundation.org>
	<CAKocOOM-QZ88+sV40C8OJWAN89W4QkDKx+gLjrmZEeUs=CJ57g@mail.gmail.com>
Date: Fri, 7 Dec 2012 17:52:14 -0700
Message-ID: <CAKocOOOKAeD=BuRnDa6U7KtHOXAK7b-VCibQohPGkAB-ZYX4aA@mail.gmail.com>
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

On Fri, Dec 7, 2012 at 5:49 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, Dec 6, 2012 at 5:54 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 3.4.23 release.
>> There are 20 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Dec  9 00:50:03 UTC 2012.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.23-rc1.gz
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Patche applied cleanly and compiled and booted on the following systems:
>
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>
> Cross-compile tests
> alpha: defconfig passed
> arm: defconfig passed
> c6x: defconfig passed
> mips: defconfig passed
> mipsel: defconfig passed
> powerpc: wii_defconfig passed
> sh: defconfig passed
> sparc: defconfig passed
> tile: tilegx_defconfig passed

Correction.
tile: tilegx_defconfig failed:

tile tilegx_defconfig

Just a snippet, I can send a full log.

 LD      init/built-in.o
  HOSTCC  usr/gen_init_cpio
  /home/shuah/lkml/linux_stable_testing_3.0.56/scripts/gen_initramfs_list.sh:
Cannot open 'usr/contents.txt'
make[1]: *** [usr/initramfs_data.cpio] Error 1
make: *** [usr] Error 2

Didn't get a chance to investigate.

-- Shuah
