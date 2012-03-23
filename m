Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab2CWSdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 14:33:43 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:20452 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2CWSdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 14:33:41 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OIsRm3QaL/j9EMhVkl6J1
Date: Fri, 23 Mar 2012 11:33:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 5/9] tty/serial/omap: console can only be built-in
Message-ID: <20120323183339.GH9859@atomide.com>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
 <1332522836-29517-6-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-6-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:16]:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When the omap serial driver is built as a module, we must
> not allow the console driver to be selected, because consoles
> can not be loadable modules.

Looks valid to me, this should get posted and merged via
linux-serial@vger.kernel.org.

Tony

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Acked-by: Govindraj.R <govindraj.raja@ti.com>
> ---
>  drivers/tty/serial/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 2de9924..bcf7e24 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1041,7 +1041,7 @@ config SERIAL_OMAP
>  
>  config SERIAL_OMAP_CONSOLE
>  	bool "Console on OMAP serial port"
> -	depends on SERIAL_OMAP
> +	depends on SERIAL_OMAP=y
>  	select SERIAL_CORE_CONSOLE
>  	help
>  	  Select this option if you would like to use omap serial port as
> -- 
> 1.7.5.4
> 
