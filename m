Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab1LOIf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:35:58 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52694 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab1LOIf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:35:57 -0500
MIME-Version: 1.0
In-Reply-To: <1323931602.3305.1.camel@phoenix>
References: <1323931602.3305.1.camel@phoenix>
Date: Thu, 15 Dec 2011 16:35:56 +0800
Message-ID: <CAN1soZyfvkkRG4oU-6POPEG0vwcuhLPYgbv39wbMrzxOBHBq2w@mail.gmail.com>
Subject: Re: [PATCH RESEND] rtc: convert drivers/rtc/* to use module_platform_driver()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben@simtec.co.uk>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 2:46 PM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/rtc/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Ben Dooks <ben@simtec.co.uk>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> This patch was sent on https://lkml.org/lkml/2011/11/25/127.
> I regenerate the patch against linux-next 20111214.
> Also Cc Andrew Morton who seems to be mostly handing
> the RTC stuff at the moment.
>
> Axel
>
>  drivers/rtc/rtc-88pm860x.c |   12 +-----------
>  drivers/rtc/rtc-ab8500.c   |   12 +-----------
>  drivers/rtc/rtc-bfin.c     |   13 +------------
>  drivers/rtc/rtc-bq4802.c   |   13 +------------
>  drivers/rtc/rtc-dm355evm.c |   12 +-----------
>  drivers/rtc/rtc-ds1286.c   |   13 +------------
>  drivers/rtc/rtc-ds1511.c   |   15 +--------------
>  drivers/rtc/rtc-ds1553.c   |   13 +------------
>  drivers/rtc/rtc-ds1742.c   |   13 +------------
>  drivers/rtc/rtc-jz4740.c   |   12 +-----------
>  drivers/rtc/rtc-lpc32xx.c  |   12 +-----------
>  drivers/rtc/rtc-m48t35.c   |   13 +------------
>  drivers/rtc/rtc-m48t59.c   |   13 +------------
>  drivers/rtc/rtc-m48t86.c   |   13 +------------
>  drivers/rtc/rtc-max8925.c  |   12 +-----------
>  drivers/rtc/rtc-max8998.c  |   12 +-----------
>  drivers/rtc/rtc-mpc5121.c  |   12 +-----------
>  drivers/rtc/rtc-mrst.c     |   13 +------------
>  drivers/rtc/rtc-pcf50633.c |   12 +-----------
>  drivers/rtc/rtc-pm8xxx.c   |   12 +-----------
>  drivers/rtc/rtc-puv3.c     |   16 +---------------
>  drivers/rtc/rtc-s3c.c      |   16 +---------------
>  drivers/rtc/rtc-sa1100.c   |   13 +------------
>  drivers/rtc/rtc-spear.c    |   12 +-----------
>  drivers/rtc/rtc-stk17ta8.c |   13 +------------
>  drivers/rtc/rtc-stmp3xxx.c |   13 +------------
>  drivers/rtc/rtc-v3020.c    |   13 +------------
>  drivers/rtc/rtc-vr41xx.c   |   13 +------------
>  drivers/rtc/rtc-vt8500.c   |   12 +-----------
>  drivers/rtc/rtc-wm831x.c   |   12 +-----------
>  drivers/rtc/rtc-wm8350.c   |   12 +-----------
>  31 files changed, 31 insertions(+), 366 deletions(-)
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
