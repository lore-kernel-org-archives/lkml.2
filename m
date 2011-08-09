Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab1HINpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:45:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40565 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HINpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:45:35 -0400
Date: Tue, 9 Aug 2011 15:45:28 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: randy.dunlap@oracle.com, dtor@mail.ru, dmitry.torokhov@gmail.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v1 08/11] Touch: DA9052 touchscreen driver
Message-ID: <20110809134528.GB31042@pengutronix.de>
References: <1310633890.284.90.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310633890.284.90.camel@L-0532.kpit.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:42:00 up 25 days,  5:12, 19 users,  load average: 0.06, 0.25,
 0.17
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2::65
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Thu, Jul 14, 2011 at 02:28:10PM +0530, ashishj3 wrote:
> This driver add support for DA9052 4-wire resistive ADC interfaced touchscreen
> controller.
> 
> DA9052 is a MFD therefore this driver depends on DA9052 core driver for core
> functionalities.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  drivers/input/touchscreen/Kconfig      |    7 +
>  drivers/input/touchscreen/Makefile     |    1 +
>  drivers/input/touchscreen/da9052_tsi.c |  489 ++++++++++++++++++++++++++++++++
>  3 files changed, 497 insertions(+), 0 deletions(-)
>  create mode 100755 drivers/input/touchscreen/da9052_tsi.c
[snip]
> +	ret = da9052_clear_bits(da9052, DA9052_GPIO_4_5_REG, 0x33);
> +	if (ret < 0)
> +		return -EIO;
> +
> +	ret = da9052_clear_bits(da9052, DA9052_GPIO_6_7_REG, 0x33);

Those two register defines are missing in your posted MFD driver headerfile "reg.h".

Regards,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
