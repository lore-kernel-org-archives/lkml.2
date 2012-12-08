Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2LHA5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:57:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58669 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2LHA5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:57:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121207005613.189054768@linuxfoundation.org>
References: <20121207005613.189054768@linuxfoundation.org>
Date: Fri, 7 Dec 2012 17:57:36 -0700
Message-ID: <CAKocOON=mAhDU6naqOi0pPdraRe__HKzhadYae6=Mp0bVFYcBA@mail.gmail.com>
Subject: Re: [ 00/11] 3.0.56-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 5:56 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.0.56 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Dec  9 00:55:07 UTC 2012.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.56-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patches and compiled and booted on the following systems:

HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

Cross-compile tests
alpha: defconfig passed
arm: defconfig passed
c6x: not applicable to 3.0.56
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig failed on 3.0.56 - sending a patch
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig failed:

 LD      init/built-in.o
  HOSTCC  usr/gen_init_cpio
  /home/shuah/lkml/linux_stable_testing_3.0.56/scripts/gen_initramfs_list.sh:
Cannot open 'usr/contents.txt'
make[1]: *** [usr/initramfs_data.cpio] Error 1
make: *** [usr] Error 2

-- Shuah
