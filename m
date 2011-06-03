Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1FCLFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:05:51 -0400
Received: from smtp0.epfl.ch ([128.178.224.219]:55665 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751803Ab1FCLFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:05:50 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 07:05:49 EDT
From: Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Organization: EPFL - STI - LSRO1
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/4] ARM: mxc: migrate mach-imx gpio driver to gpio-mxc
Date: Fri, 3 Jun 2011 12:59:06 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.14-desktop-1mnb; KDE/4.3.5; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, patches@linaro.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de, olof@lixom.net
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org> <1306985632-18820-4-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1306985632-18820-4-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106031259.06088.philippe.retornaz@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi, 2 juin 2011 05.33:51, Shawn Guo a écrit :

> diff --git a/arch/arm/mach-imx/mach-mx31moboard.c
>  b/arch/arm/mach-imx/mach-mx31moboard.c index eaa51e4..a52fd36 100644
> --- a/arch/arm/mach-imx/mach-mx31moboard.c
> +++ b/arch/arm/mach-imx/mach-mx31moboard.c
> @@ -507,6 +507,8 @@ core_param(mx31moboard_baseboard,
>  mx31moboard_baseboard, int, 0444); */
>  static void __init mx31moboard_init(void)
>  {
> +	imx31_soc_init();
> +
>  	mxc_iomux_setup_multiple_pins(moboard_pins, ARRAY_SIZE(moboard_pins),
>  		"moboard");
> 

Acked-by: Philippe Retornaz <philippe.retornaz@epfl.ch>

Thanks,

Philippe
