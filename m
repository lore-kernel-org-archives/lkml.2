Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1I1I1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:27:22 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:36968 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1I1I1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:27:21 -0400
Message-ID: <4E82DA5E.6070906@atmel.com>
Date: Wed, 28 Sep 2011 10:27:10 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Subject: Re: [PATCH for 3.1] ARM: at91: add PWM driver selector in Kconfig
 for 9g45 family
References: <1316710934-22405-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1316710934-22405-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/09/2011 19:02, Nicolas Ferre :
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/misc/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 2d6423c..7ce658e 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -63,7 +63,7 @@ config AD525X_DPOT_SPI
>  
>  config ATMEL_PWM
>  	tristate "Atmel AT32/AT91 PWM support"
> -	depends on AVR32 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9
> +	depends on AVR32 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9

I am rethinking about that just planning to remove entirely this "depends" line...

>  	help
>  	  This option enables device driver support for the PWM channels
>  	  on certain Atmel processors.  Pulse Width Modulation is used for

---8<--------
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 28 Sep 2011 09:38:44 +0200
Subject: [PATCH for 3.1 V2] ARM: at91: add PWM driver selector in Kconfig for 9g45 family

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2d6423c..7ce658e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -63,7 +63,6 @@ config AD525X_DPOT_SPI
 
 config ATMEL_PWM
 	tristate "Atmel AT32/AT91 PWM support"
-	depends on AVR32 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9
 	help
 	  This option enables device driver support for the PWM channels
 	  on certain Atmel processors.  Pulse Width Modulation is used for

-- 
Nicolas Ferre

