Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965603Ab2JDO73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:59:29 -0400
Received: from smtp-out-072.synserver.de ([212.40.185.72]:1099 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965439Ab2JDO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:59:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17355
Message-ID: <506DA487.9070400@metafoo.de>
Date: Thu, 04 Oct 2012 17:00:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH] pwm: Get rid of HAVE_PWM
References: <1349330819-11924-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1349330819-11924-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 08:06 AM, Thierry Reding wrote:
> [...]
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 331d574..b38f23d 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -219,7 +219,8 @@ config MACH_JZ4740
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
>  	select SYS_HAS_EARLY_PRINTK
> -	select HAVE_PWM
> +	select PWM
> +	select PWM_JZ4740
>  	select HAVE_CLK
>  	select GENERIC_IRQ_CHIP

I'm not sure if this is such a good idea, not all jz4740 based board
necessarily require PWM.

- Lars

