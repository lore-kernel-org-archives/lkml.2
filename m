Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1FBFYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:24:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38913 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1FBFYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:24:13 -0400
MIME-Version: 1.0
X-Originating-IP: [230.229.188.175]
In-Reply-To: <1306985632-18820-2-git-send-email-shawn.guo@linaro.org>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
	<1306985632-18820-2-git-send-email-shawn.guo@linaro.org>
Date: Wed, 1 Jun 2011 22:24:12 -0700
Message-ID: <BANLkTinwnoAA-p2+b_Q--NFjHfKCG81d9g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] gpio: gpio-mxc: add gpio driver for Freescale MXC architecture
From: Olof Johansson <olof@lixom.net>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, arnd@arndb.de,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 8:33 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> Add gpio-mxc driver by copying arch/arm/plat-mxc/gpio.c into
> drivers/gpio with the following changes.
>
>  * Use readl/writel to replace mach-specific accessors
>   __raw_readl/__raw_writel
>
>  * Migrate to platform driver by adding .probe function
>
>  * Add a list to save all mx2 ports references, so that
>   mx2_gpio_irq_handler can walk through all interrupt status
>   registers
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
