Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1FBFUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:20:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34906 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1FBFUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:20:16 -0400
MIME-Version: 1.0
X-Originating-IP: [230.229.188.175]
In-Reply-To: <1306985632-18820-5-git-send-email-shawn.guo@linaro.org>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
	<1306985632-18820-5-git-send-email-shawn.guo@linaro.org>
Date: Wed, 1 Jun 2011 22:20:14 -0700
Message-ID: <BANLkTimX5moosFQbc_37-E+rOxqSwAm7jA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: mxc: remove plat-mxc/gpio driver
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
> With all users of plat-mxc/gpio migrated to drivers/gpio/gpio-mxc,
> plat-mxc/gpio can be removed now.  And plat-mxc/include/mach/gpio.h
> can also be cleaned up as below.
>
>  * Remove the helper macros for gpio ports definition
>  * Move "struct mxc_gpio_port" into drivers/gpio/gpio-mxc.c, as it's
>   not needed to be public at all
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Olof Johansson <olof@lixom.net>
