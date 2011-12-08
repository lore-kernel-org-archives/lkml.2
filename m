Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1LHBgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:36:47 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38310 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757002Ab1LHBgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:36:46 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111207212109.GA1314@pengutronix.de>
References: <1323071447.20963.3.camel@phoenix> <20111207212109.GA1314@pengutronix.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 8 Dec 2011 09:36:23 +0800
Message-ID: <CAF+7xWmnYsjM-mcx=2pvKavE6RAnLFv2Ey0N1+0_n46G3Km27w@mail.gmail.com>
Subject: Re: [PATCH] spi: use gpio_request_one() instead of spi_gpio_alloc()
 helper function
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/8 Wolfram Sang <w.sang@pengutronix.de>:
> On Mon, Dec 05, 2011 at 03:50:47PM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> This will make the driver depend on GPIOLIB, currently it depends only
> on GENERIC_GPIO. That needs to be addressed and made sure it won't cause
> a regression for the in-kernel users.
>
Ah. You are right.
GPIOLIB can be optional or not available at all in some
architecture/configurations.
Thanks for your review.

Axel
