Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab0JUMt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:49:59 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:50117 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754615Ab0JUMt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:49:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 08:49:58 EDT
Message-ID: <4CC03563.3060908@example.com>
Date: Thu, 21 Oct 2010 14:43:15 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: rklein@nvidia.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        broonie@opensource.wolfsonmicro.com, achew@nvidia.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] POWER: Add gpio chager driver
References: <4CC02FF9.3050804@metafoo.de> <1287663957-30099-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1287663957-30099-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3847199983095476565
X-Ovh-Remote: 83.6.193.136 (abbd136.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2010 14:25, Lars-Peter Clausen wrote:
> This patch adds a simple driver for chargers indicating their online status
> through a GPIO pin.
>
> Signed-off-by: Lars-Peter Clausen<lars@metafoo.de>
> ---
>   drivers/power/Kconfig              |   10 ++
>   drivers/power/Makefile             |    1 +
>   drivers/power/gpio-charger.c       |  184 ++++++++++++++++++++++++++++++++++++
>   include/linux/power/gpio-charger.h |   39 ++++++++
>   4 files changed, 234 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/power/gpio-charger.c
>   create mode 100644 include/linux/power/gpio-charger.h
>
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 0734356..90b1940 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -166,4 +166,14 @@ config BATTERY_INTEL_MID
>   	  Say Y here to enable the battery driver on Intel MID
>   	  platforms.
>
> +config CHARGER_GPIO
> +	tristate "GPIO charger"
> +	depends on GPIOLIB
> +	help
> +	  Say Y to include support for chargers which report their online status
> +	  through a GPIO pin.
> +
> +	  This driver can be build as a module. If so, the module will be
> +	  called gpio-chager.

Shouldn't it say gpio-charger not gpio-chager? A typo.

Regards,

Piotr Hosowicz

-- 
Radzieccy neurolodzy odkryli nerw ³±cz±cy oko bezpo¶rednio z dup±.
Kiedy uk³uli pacjenta ig³± w dupê, w jego oku pojawi³a siê ³za.
Kiedy wbili tê sam± ig³ê w oko, pacjent siê zesra³.
NP: Peter Green Splinter Group - Indians
NB: 2.6.36
