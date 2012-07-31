Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2GaU6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:58:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GaU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:58:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/6] ARM: ux500: Fix merge error, so such struct 'snd_soc_u8500'
Date: Tue, 31 Jul 2012 20:58:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-9-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1343741493-17671-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207312058.03640.arnd@arndb.de>
X-Provags-ID: V02:K0:Nr0BbuZVnN8YchBwDv25hn39t7jOQO895hr5sR48sYw
 3o4HZ2ax1VMViXhyK1ZrDo9Wn6kMo8/T94NwTK1t7X9tt42hs3
 TwqugPn17t9Wn2OUiBH73AHQVIH6oh37F73poWPHMX11p/Ofhj
 1oF3BQ/khT29mWSZ2uy6F6JcyPuvnYqVa9E1MdFmXoka8ovp2w
 ikHlS5i1SfZ9AOYzNEr8ex8qIU/ToMbktDc30s5XtVsVi2s/In
 F2mmjhVtxdPZ86iOE41ngpXYbaw0FYZyVmNPVJTA/OvCSmvNVK
 18k+TAmSAZ82RKGYNUQi4WN6Q2cwvKphFnrzNzjjcY7WuPbOi8
 migifO5XHNFGfk7dUhf8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Lee Jones wrote:
>  arch/arm/mach-ux500/board-mop500-msp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
> index 9960480..1b6a193 100644
> --- a/arch/arm/mach-ux500/board-mop500-msp.c
> +++ b/arch/arm/mach-ux500/board-mop500-msp.c
> @@ -228,7 +228,7 @@ int mop500_msp_init(struct device *parent)
>         struct platform_device *msp1;
>  
>         pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
> -       platform_device_register(&snd_soc_u8500);
> +       platform_device_register(&snd_soc_mop500);
>  
>         pr_info("Initialize MSP I2S-devices.\n");
>         db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,

Against which tree is this? In upstream I only see the snd_soc_u8500 device,
not snd_soc_mop500.

	Arnd
