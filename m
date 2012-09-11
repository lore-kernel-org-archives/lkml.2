Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab2IKRM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:12:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45504 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759659Ab2IKRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:12:12 -0400
Message-ID: <504F70E5.4050303@pobox.com>
Date: Tue, 11 Sep 2012 13:12:05 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 15/16] ARM: samsung: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368559-31329-1-git-send-email-arnd@arndb.de> <1347368559-31329-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1347368559-31329-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 09:02 AM, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
>
> This moves such data out of the samsung include directories
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Sangbeom Kim <sbkim73@samsung.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: linux-samsung-soc@vger.kernel.org
> ---
>   arch/arm/mach-exynos/dev-audio.c                   |    2 +-
>   arch/arm/mach-exynos/dev-ohci.c                    |    2 +-
>   arch/arm/mach-exynos/mach-nuri.c                   |    6 +++---
>   arch/arm/mach-exynos/mach-origen.c                 |    6 +++---
>   arch/arm/mach-exynos/mach-smdk4x12.c               |    2 +-
>   arch/arm/mach-exynos/mach-smdkv310.c               |    6 +++---
>   arch/arm/mach-exynos/mach-universal_c210.c         |    4 ++--
>   arch/arm/mach-exynos/setup-i2c0.c                  |    2 +-
>   arch/arm/mach-exynos/setup-i2c1.c                  |    2 +-
>   arch/arm/mach-exynos/setup-i2c2.c                  |    2 +-
>   arch/arm/mach-exynos/setup-i2c3.c                  |    2 +-
>   arch/arm/mach-exynos/setup-i2c4.c                  |    2 +-
>   arch/arm/mach-exynos/setup-i2c5.c                  |    2 +-
>   arch/arm/mach-exynos/setup-i2c6.c                  |    2 +-
>   arch/arm/mach-exynos/setup-i2c7.c                  |    2 +-
>   arch/arm/mach-s3c24xx/common-smdk.c                |    4 ++--
>   arch/arm/mach-s3c24xx/mach-amlm5900.c              |    2 +-
>   arch/arm/mach-s3c24xx/mach-anubis.c                |    6 +++---
>   arch/arm/mach-s3c24xx/mach-at2440evb.c             |    6 +++---
>   arch/arm/mach-s3c24xx/mach-bast.c                  |    8 ++++----
>   arch/arm/mach-s3c24xx/mach-gta02.c                 |   10 +++++-----
>   arch/arm/mach-s3c24xx/mach-h1940.c                 |    8 ++++----
>   arch/arm/mach-s3c24xx/mach-jive.c                  |    6 +++---
>   arch/arm/mach-s3c24xx/mach-mini2440.c              |   10 +++++-----
>   arch/arm/mach-s3c24xx/mach-n30.c                   |    8 ++++----
>   arch/arm/mach-s3c24xx/mach-nexcoder.c              |    2 +-
>   arch/arm/mach-s3c24xx/mach-osiris.c                |    4 ++--
>   arch/arm/mach-s3c24xx/mach-otom.c                  |    2 +-
>   arch/arm/mach-s3c24xx/mach-qt2410.c                |    8 ++++----
>   arch/arm/mach-s3c24xx/mach-rx1950.c                |   10 +++++-----
>   arch/arm/mach-s3c24xx/mach-rx3715.c                |    2 +-
>   arch/arm/mach-s3c24xx/mach-smdk2410.c              |    2 +-
>   arch/arm/mach-s3c24xx/mach-smdk2413.c              |    4 ++--
>   arch/arm/mach-s3c24xx/mach-smdk2416.c              |    8 ++++----
>   arch/arm/mach-s3c24xx/mach-smdk2440.c              |    2 +-
>   arch/arm/mach-s3c24xx/mach-smdk2443.c              |    2 +-
>   arch/arm/mach-s3c24xx/mach-tct_hammer.c            |    2 +-
>   arch/arm/mach-s3c24xx/mach-vr1000.c                |    6 +++---
>   arch/arm/mach-s3c24xx/mach-vstms.c                 |    4 ++--
>   arch/arm/mach-s3c24xx/setup-i2c.c                  |    2 +-
>   arch/arm/mach-s3c24xx/simtec-audio.c               |    2 +-
>   arch/arm/mach-s3c24xx/simtec-usb.c                 |    2 +-
>   arch/arm/mach-s3c64xx/dev-audio.c                  |    2 +-
>   arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
>   arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
>   arch/arm/mach-s3c64xx/mach-crag6410.c              |    4 ++--
>   arch/arm/mach-s3c64xx/mach-hmt.c                   |    4 ++--
>   arch/arm/mach-s3c64xx/mach-mini6410.c              |    4 ++--
>   arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
>   arch/arm/mach-s3c64xx/mach-real6410.c              |    4 ++--
>   arch/arm/mach-s3c64xx/mach-smartq.c                |    8 ++++----
>   arch/arm/mach-s3c64xx/mach-smdk6400.c              |    2 +-
>   arch/arm/mach-s3c64xx/mach-smdk6410.c              |    6 +++---
>   arch/arm/mach-s3c64xx/setup-i2c0.c                 |    2 +-
>   arch/arm/mach-s3c64xx/setup-i2c1.c                 |    2 +-
>   arch/arm/mach-s3c64xx/setup-ide.c                  |    2 +-
>   arch/arm/mach-s5p64x0/dev-audio.c                  |    2 +-
>   arch/arm/mach-s5p64x0/mach-smdk6440.c              |    4 ++--
>   arch/arm/mach-s5p64x0/mach-smdk6450.c              |    4 ++--
>   arch/arm/mach-s5p64x0/setup-i2c0.c                 |    2 +-
>   arch/arm/mach-s5p64x0/setup-i2c1.c                 |    2 +-
>   arch/arm/mach-s5pc100/dev-audio.c                  |    2 +-
>   arch/arm/mach-s5pc100/mach-smdkc100.c              |    8 ++++----
>   arch/arm/mach-s5pc100/setup-i2c0.c                 |    2 +-
>   arch/arm/mach-s5pc100/setup-i2c1.c                 |    2 +-
>   arch/arm/mach-s5pv210/dev-audio.c                  |    2 +-
>   arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
>   arch/arm/mach-s5pv210/mach-smdkc110.c              |    4 ++--
>   arch/arm/mach-s5pv210/mach-smdkv210.c              |    6 +++---
>   arch/arm/mach-s5pv210/mach-torbreck.c              |    2 +-
>   arch/arm/mach-s5pv210/setup-i2c0.c                 |    2 +-
>   arch/arm/mach-s5pv210/setup-i2c1.c                 |    2 +-
>   arch/arm/mach-s5pv210/setup-i2c2.c                 |    2 +-
>   arch/arm/plat-samsung/devs.c                       |   20 ++++++++++----------
>   drivers/ata/pata_samsung_cf.c                      |    2 +-

Acked-by: Jeff Garzik <jgarzik@redhat.com>



