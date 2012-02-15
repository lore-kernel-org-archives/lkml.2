Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2BOIFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 03:05:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61709 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757912Ab2BOIFT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 03:05:19 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1329292870.13730.0.camel@phoenix>
References: <1329292870.13730.0.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 15 Feb 2012 16:04:58 +0800
Message-ID: <CAF+7xWmjWvuVxvJuY2E4DzvQY-Dd4kZKUzpUThutRAD0vrj22Q@mail.gmail.com>
Subject: Re: [PATCH] mfd: Fix typo for TPS95912
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya <magi@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just found another typo. It is TPS65912, not TPS95912.
Pls ignore this patch. I'm sending a v2 now.

2012/2/15 Axel Lin <axel.lin@gmail.com>:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index bd60ce0..b725d0b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -171,7 +171,7 @@ config MFD_TPS65912
>        depends on GPIOLIB
>
>  config MFD_TPS65912_I2C
> -       bool "TPS95612 Power Management chip with I2C"
> +       bool "TPS95912 Power Management chip with I2C"
>        select MFD_CORE
>        select MFD_TPS65912
>        depends on I2C=y && GPIOLIB
> --
> 1.7.5.4
>
>
>
