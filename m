Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab1CGX1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:27:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34651 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab1CGX12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:27:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bf4eBdxxgoJcBW1489steVMJArx2J+NZSHOuEr8LtIbsSu4cMOsaE73WZwuOymhs5W
         4LeJn9YPT3r9fT5XdfErgR+e3W+3M5pyCkeD3iKtogqRIeGJchqYqsq25AU6IH6ZlJRt
         7YP9MbEKN6oYMLNusxQMbnSWd2LwdRIy/YZU8=
MIME-Version: 1.0
In-Reply-To: <038701cbdd1b$1c11b890$543529b0$%kim@samsung.com>
References: <038701cbdd1b$1c11b890$543529b0$%kim@samsung.com>
Date: Tue, 8 Mar 2011 08:27:26 +0900
X-Google-Sender-Auth: 8g9QuKM26KevTL23sGUM--TYYCs
Message-ID: <AANLkTikcmkPAjb0b7PBgATCf6bYOhiQOQK4w5hxggttZ@mail.gmail.com>
Subject: Re: [GIT PULL] Samsung fixes for 2.6.38-rc8
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you also add this one?
ARM: Samsung: change suspend/resume code to depend on CONFIG_SUSPEND
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg04141.html

Even though suspend is not implemented at exynos4, we can use the
runtime pm feature.
Also without this patch, we can't compile the exynos4 when turn on PM.

Thank you,
Kyungmin Park

On Tue, Mar 8, 2011 at 7:57 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Hi Linus,
>
> Please pull Samsung fixes from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> These things are for small fixes on 2.6.38-rc8.
> If any problems, please let me know.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
> The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:
>
>  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)
>
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> Banajit Goswami (1):
>      ARM: S5P64X0: Fix number of GPIO lines in Bank F
>
> Ben Dooks (3):
>      ARM: S3C64XX: Fix keypad setup to configure correct number of rows
>      ARM: S3C64XX: Add clock for i2c1
>      ARM: S3C64XX: Reduce output of s3c64xx_dma_init1()
>
> Lars-Peter Clausen (2):
>      ARM: S3C2440: Select missing S3C_DEV_USB_HOST on GTA02
>      ARM: S3C2440: Fix usage gpio bank j pin definitions on GTA02
>
> Mark Brown (5):
>      ARM: SAMSUNG: Include devs.h in dev-uart.c to prototype devices
>      ARM: S3C64XX: Staticise non-exported GPIO to interrupt functions
>      ARM: S3C64XX: Tone down SDHCI debugging
>      ARM: S3C64XX: Fix build with WM1190 disabled and WM1192 enabled on
> SMDK6410
>      ARM: S3C64XX: Update regulator names for debugfs compatiblity on
> SMDK6410
>
>  arch/arm/mach-s3c2440/Kconfig              |    1 +
>  arch/arm/mach-s3c2440/include/mach/gta02.h |   26
> +++++++++++++-------------
>  arch/arm/mach-s3c64xx/clock.c              |    6 ++++++
>  arch/arm/mach-s3c64xx/dma.c                |   11 ++++++-----
>  arch/arm/mach-s3c64xx/gpiolib.c            |    4 ++--
>  arch/arm/mach-s3c64xx/mach-smdk6410.c      |   13 +++++++------
>  arch/arm/mach-s3c64xx/setup-keypad.c       |    2 +-
>  arch/arm/mach-s3c64xx/setup-sdhci.c        |    2 +-
>  arch/arm/mach-s5p64x0/include/mach/gpio.h  |    4 ++--
>  arch/arm/plat-samsung/dev-uart.c           |    2 ++
>  10 files changed, 41 insertions(+), 30 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
