Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2KTQIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:08:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42244 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2KTQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:08:22 -0500
Date: Tue, 20 Nov 2012 16:08:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/2] ARM: ux500: Disable the MMCI gpio-regulator by
 default
Message-ID: <20121120160816.GB28265@gmail.com>
References: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Lee Jones wrote:

> Not all supported boards will require a MMCI gpio-regulator,
> therefore it's a good idea to only enable the node when and if
> it is required. Let's disable it by default.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/dbx5x0.dtsi |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
> index 7ce45fc..d8ba489 100644
> --- a/arch/arm/boot/dts/dbx5x0.dtsi
> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> @@ -642,6 +642,8 @@
>  			gpio-enable = <&tc3589x_gpio 17 0x4>;
>  			states = <1800000 0x1
>  				  2900000 0x0>;
> +
> +			status = "disabled";
>  		};
>  	};
>  };
> -- 
> 1.7.9.5
> 

Prod for Linus.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
