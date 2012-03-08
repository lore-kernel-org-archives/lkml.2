Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2CHGYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:24:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47812 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2CHGYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:24:39 -0500
MIME-Version: 1.0
In-Reply-To: <20120307173157.GT3107@opensource.wolfsonmicro.com>
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
	<20120307173157.GT3107@opensource.wolfsonmicro.com>
Date: Thu, 8 Mar 2012 07:24:39 +0100
Message-ID: <CACRpkdaEHOGA2XfW1SMJodyf9oTNRF7kk9ErQeSpBv_2TFj=Rg@mail.gmail.com>
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 6:31 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Mar 07, 2012 at 07:08:14PM +0530, Laxman Dewangan wrote:
>> The gpio core driver (gpio library) supports the open
>> drain pin handling. Therefore, it is not require it
>> to handle in the i2c-gpio driver, just require
>> to pass the OPEN_DRAIN type flag when requesting the gpio.
>
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> but note that this is a new gpiolib feature in -next and will need to
> either be applied via Grant's tree or wait until after the merge window.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
I'd ask Grant to take this into the GPIO tree if Broonie can ACK it.

Yours,
Linus Walleij
