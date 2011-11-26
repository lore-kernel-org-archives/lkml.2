Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1KZC7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 21:59:54 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61381 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1KZC7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 21:59:53 -0500
MIME-Version: 1.0
In-Reply-To: <1322273963.10633.1.camel@phoenix>
References: <1322273963.10633.1.camel@phoenix>
Date: Sat, 26 Nov 2011 10:59:52 +0800
Message-ID: <CAN1soZz0jVjEQg_Com=Ge+4KrDFjnnhOK+5oD=+wz1BiuuGSOQ@mail.gmail.com>
Subject: Re: [PATCH] backlight: convert drivers/video/backlight/* to use module_platform_driver()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 10:19 AM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/video/backlight/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mike Rapoport <mike@compulab.co.il>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/backlight/88pm860x_bl.c        |   12 +-----------
>  drivers/video/backlight/adp5520_bl.c         |   12 +-----------
>  drivers/video/backlight/adx_bl.c             |   13 +------------
>  drivers/video/backlight/da903x_bl.c          |   12 +-----------
>  drivers/video/backlight/ep93xx_bl.c          |   12 +-----------
>  drivers/video/backlight/generic_bl.c         |   13 +------------
>  drivers/video/backlight/jornada720_bl.c      |   13 +------------
>  drivers/video/backlight/jornada720_lcd.c     |   13 +------------
>  drivers/video/backlight/max8925_bl.c         |   12 +-----------
>  drivers/video/backlight/omap1_bl.c           |   13 +------------
>  drivers/video/backlight/pcf50633-backlight.c |   12 +-----------
>  drivers/video/backlight/platform_lcd.c       |   13 +------------
>  drivers/video/backlight/pwm_bl.c             |   12 +-----------
>  drivers/video/backlight/wm831x_bl.c          |   12 +-----------
>  14 files changed, 14 insertions(+), 160 deletions(-)
>
Acked-by Haojian Zhuang <haojian.zhuang@gmail.com>
