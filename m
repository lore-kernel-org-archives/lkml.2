Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab1EKQKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:10:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60468 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab1EKQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:10:25 -0400
Subject: Re: [PATCH] mfd: TPS65910 depends on I2C and must be built in
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1305103667-17454-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110511122738.93d239cb.sfr@canb.auug.org.au>
	 <1305103667-17454-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 14:35:18 +0100
Message-ID: <1305120918.3277.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 10:47 +0200, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index c78865e..0131d49 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -673,7 +673,7 @@ config MFD_OMAP_USB_HOST
>  
>  config MFD_TPS65910
>  	bool "TPS65910 Power Management chip"
> -	depends on I2C && GPIOLIB
> +	depends on I2C=y && GPIOLIB
>  	select MFD_CORE
>  	help
>  	  if you say yes here you get support for the TPS65910 series of

Thanks, Applied the exact same patch from Jorge (sent a few hours
before).

Thanks

Liam 

