Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2LHA6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:58:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38116 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2LHA6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:58:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOMkwXyp4uUDyhSj=LMiCoAMk0mqTb+Z3m0uxR218hmaRw@mail.gmail.com>
References: <20121207005825.232489605@linuxfoundation.org>
	<CAKocOOMkwXyp4uUDyhSj=LMiCoAMk0mqTb+Z3m0uxR218hmaRw@mail.gmail.com>
Date: Fri, 7 Dec 2012 17:58:15 -0700
Message-ID: <CAKocOOOGETS4yhXsJKMpLk-2LhBFkV39ZxW7tQ7Lta18oBt0TA@mail.gmail.com>
Subject: Re: [ 00/27] 3.6.10-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 5:46 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, Dec 6, 2012 at 5:58 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 3.6.10 release.
>> There are 27 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Dec  9 00:57:22 UTC 2012.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.10-rc1.gz
>> and the diffstat can be found below.
>>
>> thanks,
>
> Patch applied cleanly and compiled and booted on the following systems:
>
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>
> Cross-compile tests
> alpha: defconfig passed
> arm: defconfig passed
> c6x: not applicable
> mips: defconfig passed
> mipsel: defconfig passed
> powerpc: wii_defconfig failed on 3.0.56 - fixed it and sending a patch.
> sh: defconfig passed on all
> sparc: defconfig passed on all
> tile: tilegx_defconfig passed on all

Correction: c6x passed.

-- Shuah
