Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0KZS0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:26:55 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38344 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab0KZS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:26:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HK48uKh5PBmT5gAz/jFHRO8anqAJ/IaU2dWRLN9jOiChyFzRPf7YkywB739okKOrY7
         k3cmVl5qWt/DTel3SCLs+ngLTUTr+W6FrQ503iPbSucn5ksrCdQ+8lcAf6pPKFT/I/9c
         COVDdRyh3KVXXiSsQcv2zSDzv9ACDfaHlschc=
Message-ID: <4CEFFBE6.9040909@gmail.com>
Date: Fri, 26 Nov 2010 20:26:46 +0200
From: Darius Augulis <augulis.darius@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Subject: Re: [GIT PULL] Samsung fixes for 2.6.37-rc4
References: <008201cb8c58$363980e0$a2ac82a0$%kim@samsung.com>
In-Reply-To: <008201cb8c58$363980e0$a2ac82a0$%kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

you have missed "serial: samsung: fix device name" again.
Please, don't forget to add it to your tree, better do it right now. 
Perhaps it's fifth or sixth time when remind about that...

thanks,
Darius


On 11/25/2010 06:21 AM, Kukjin Kim wrote:
> Hi Linus,
>
> Please pull Samsung fixes from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> These things are for small fix on 2.6.37-rc4.
> If any problems, please let me know.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim<kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
> The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:
>
>    Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)
>
> are available in the git repository at:
>     git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> Abhilash Kesavan (3):
>        ARM: S3C24XX: Fix Demux error in UART3 irqs on S3C2443 and S3C2416
>        ARM: S3C24XX: Fix UART3 submask on S3C2416 and S3C2443
>        ARM: S5PV210: Fix sysdev related warning messages
>
> Darius Augulis (1):
>        ARM: S3C64XX: fix uart clock setup for mini6410/real6410
>
> Kukjin Kim (1):
>        ARM: S3C24XX: Fix wrong s3c_gpio_cfgpull
>
> Vasily Khoruzhick (1):
>        ARM: S3C2410: Adapt h1940-bluetooth to gpiolib changes
>
>   arch/arm/mach-s3c2410/h1940-bluetooth.c      |    8 ++++----
>   arch/arm/mach-s3c2416/irq.c                  |    5 ++---
>   arch/arm/mach-s3c2443/irq.c                  |    5 ++---
>   arch/arm/mach-s3c64xx/mach-mini6410.c        |    2 +-
>   arch/arm/mach-s3c64xx/mach-real6410.c        |    2 +-
>   arch/arm/mach-s5pv210/mach-smdkc110.c        |    1 +
>   arch/arm/mach-s5pv210/mach-smdkv210.c        |    1 +
>   arch/arm/plat-s3c24xx/spi-bus0-gpe11_12_13.c |    6 +++---
>   arch/arm/plat-s3c24xx/spi-bus1-gpd8_9_10.c   |    6 +++---
>   arch/arm/plat-s3c24xx/spi-bus1-gpg5_6_7.c    |    6 +++---
>   10 files changed, 21 insertions(+), 21 deletions(-)
>

