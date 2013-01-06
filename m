Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3AFBnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 20:43:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48425 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3AFBns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 20:43:48 -0500
Date: Sat, 5 Jan 2013 17:40:14 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Cc: francescolavra.fl@gmail.com, rob.herring@calxeda.com, lee.jones@linaro.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com
Subject: Re: [PATCH 2/2] ab8500: promote ab8500_fg probe before ab8500_btemp
 probe
Message-ID: <20130106014013.GA15410@lizard.sbx05280.losalca.wayport.net>
References: <1354558375-15110-1-git-send-email-rajanikanth.hv@linaro.org>
 <1354558375-15110-2-git-send-email-rajanikanth.hv@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354558375-15110-2-git-send-email-rajanikanth.hv@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 11:42:55PM +0530, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> ab8500_fg driver prepares instance list of fuelgauge which is
> required by btemp driver for battery identification. So make sure
> that ab8500 fuelgauge list is ready before btemp driver starts.
> 
> for '3.7-rc5': of git://git.infradead.org/battery-2.6.git
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
> ---

This one, and "1/2 v2" applied, thanks!

>  drivers/power/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 696e3a9..070c73d 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -38,7 +38,7 @@ obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
>  obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
>  obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
>  obj-$(CONFIG_BATTERY_RX51)	+= rx51_battery.o
> -obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_btemp.o ab8500_fg.o abx500_chargalg.o
> +obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_fg.o ab8500_btemp.o abx500_chargalg.o
>  obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
>  obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
>  obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
> -- 
> 1.7.10.4
