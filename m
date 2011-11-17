Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1KQI4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:56:34 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:23217 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab1KQI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:56:33 -0500
Message-ID: <4EC4CC3C.5040106@atmel.com>
Date: Thu, 17 Nov 2011 09:56:28 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net/cadence: enable by default NET_ATMEL
References: <1321385790-15056-1-git-send-email-plagnioj@jcrosoft.com>
In-Reply-To: <1321385790-15056-1-git-send-email-plagnioj@jcrosoft.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 08:36 PM, Jean-Christophe PLAGNIOL-VILLARD :
> so the defconfig of the atmel continue to have the support of the network
> as before
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> Hi David,
> 
> 	can we have this for the 3.2 so the atmel continue to work as before
> 
> Best Regards,
> J.
>  drivers/net/ethernet/cadence/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
> index 98849a1..b48378a 100644
> --- a/drivers/net/ethernet/cadence/Kconfig
> +++ b/drivers/net/ethernet/cadence/Kconfig
> @@ -7,6 +7,7 @@ config HAVE_NET_MACB
>  
>  config NET_ATMEL
>  	bool "Atmel devices"
> +	default y
>  	depends on HAVE_NET_MACB || (ARM && ARCH_AT91RM9200)
>  	---help---
>  	  If you have a network (Ethernet) card belonging to this class, say Y.


-- 
Nicolas Ferre
