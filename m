Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab0HPRVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:21:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57968 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0HPRVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w74Skil8+GYXZpFkRm2Us0NXNwYDrblKktOFJ9X0nKiEodGyN2uJZ9u4u5Cb/FOk0s
         I03Qx8BOvgySHA4ZZEs6EWwhYFN+7Uv4X6HiDZYUU6gXEfvtKh93Ev7hs2h+h1rwAOg/
         VXwPRapMA1poBr1xilPSTYnWYcUWUU9iHJQsU=
Message-ID: <4C6973A9.2060004@gmail.com>
Date: Mon, 16 Aug 2010 20:21:45 +0300
From: Darius Augulis <augulis.darius@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com
Subject: Re: [PULL] Please pull bjdooks' for-linus/samsung-2636
References: <20100814153625.GA31271@ben-laptop.fluff.org>
In-Reply-To: <20100814153625.GA31271@ben-laptop.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2010 06:36 PM, Ben Dooks wrote:
> Hi, please pull
>
> The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:
>    Linus Torvalds (1):
>          Merge git://git.kernel.org/.../cmetcalf/linux-tile
>
> are available in the git repository at:
>
>    git://git.fluff.org/bjdooks/linux.git for-linus/samsung-2635
>
> Ben Dooks (3):
>        ARM: S3C64XX: Update consistent DMA size to 8MiB
>        ARM: SMDK6410: Make virtual screen twice depth of real
>        Merge branch 'for-2636/s3c64xx' into for-linus/samsung-2635
>
> Darius Augulis (3):
>        ARM: S3C64XX: Support for Real6410
>        ARM: mach-real6410: add dm9000 ethernet support for mach-real6410
>        ARM: mach-real6410: add sdhc device support

Probably you would like to merge v2 of these patches.
I sent v2 to ML in 08/06/2010.
As v1 is already in main line, should I prepare new patch containing 
fixes which are in v2? These fixes mostly are coding style related also 
one minor fix in dm9000 pdata.

>
> Kukjin Kim (1):
>        ARM: SAMSUNG: Fix on build warning about dependency in Kconfig
>
> Linus Walleij (1):
>        DMAENGINE: correct PL080 register header file
>
> Maurus Cuelenaere (3):
>        ARM: S3C64XX: Move SmartQ LCD control platform definition to shared file
>        ARM: S3C64XX: Set wifi and iNAND as permanently connected SD devices on SmartQ boards
>        ARM: S3C64XX: Add audio support to SmartQ
>
> Patrick Georgi (1):
>        ARM: S3C64XX: Framebuffer fix for SmartQ5
>
>   arch/arm/include/asm/hardware/pl080.h       |    4 +-
>   arch/arm/mach-s3c64xx/Kconfig               |    9 ++
>   arch/arm/mach-s3c64xx/Makefile              |    1 +
>   arch/arm/mach-s3c64xx/dma.c                 |    2 +-
>   arch/arm/mach-s3c64xx/include/mach/memory.h |    2 +
>   arch/arm/mach-s3c64xx/mach-real6410.c       |  152 +++++++++++++++++++++++++++
>   arch/arm/mach-s3c64xx/mach-smartq.c         |   40 +++++++-
>   arch/arm/mach-s3c64xx/mach-smartq5.c        |   36 +------
>   arch/arm/mach-s3c64xx/mach-smartq7.c        |   28 -----
>   arch/arm/mach-s3c64xx/mach-smdk6410.c       |    2 +
>   arch/arm/plat-samsung/Kconfig               |    2 +-
>   11 files changed, 213 insertions(+), 65 deletions(-)
>   create mode 100644 arch/arm/mach-s3c64xx/mach-real6410.c
>

