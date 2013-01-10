Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3AJSEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:04:09 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:63593 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3AJSEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:04:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
Date: Thu, 10 Jan 2013 11:04:05 -0700
Message-ID: <CAKocOOO6QVWdw8WuLKq+8Cbdu6WRV=fVQ_-jOSNoa40sUv1s=Q@mail.gmail.com>
Subject: Re: [ 000/123] 3.7.2-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:33 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Note, there are still a lot of patches submitted for inclusion in the
> stable releases that I have not gotten to yet.  I wanted to get this
> release out now, instead of delaying for a week or so while I dig
> through all of the pending patches.
>
> This is the start of the stable review cycle for the 3.7.2 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Jan 11 20:11:16 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.2-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patches applied cleanly to 3.0.y, 3.4.y, and 3.7.y.
Compiled and booted on the following systems:
HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

Cross-compile tests:
alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.7.y
c6x: not applicable to 3.0.y, defconfig passed on the rest three
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah
