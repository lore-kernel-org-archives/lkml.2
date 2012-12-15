Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab2LOUrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:47:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2LOUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:47:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOMPoaiwnCtCgcxNBUx3p=SP63uyTkQeB7Kw3KdO2Evp4A@mail.gmail.com>
References: <20121214222251.229078963@linuxfoundation.org>
	<CAKocOOMPoaiwnCtCgcxNBUx3p=SP63uyTkQeB7Kw3KdO2Evp4A@mail.gmail.com>
Date: Sat, 15 Dec 2012 13:47:08 -0700
Message-ID: <CAKocOOOamBmV0F243S_1ttywy81XQQo7dexYcNOpzGKrZq-10w@mail.gmail.com>
Subject: Re: [ 00/27] 3.7.1-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 7:22 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Fri, Dec 14, 2012 at 4:01 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 3.7.1 release.
>> There are 27 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Dec 16 22:16:56 UTC 2012.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.1-rc1.gz
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Patches applied cleanly to 3.0.y, 3.4.y, 3.6.y, and 3.7.y.
> ompiled and booted on the following systems:
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>
> I started cross-compile tests and will report the status
>
Cross-compile tests:
alpha: defconfig passed on all
arm: defconfig passed on all
c6x: not applicable to 3.0.y, defconfig passed on the rest three
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig failed on 3.0.y (known issue), passed on the rest three
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah
