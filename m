Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab2HWRxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:53:48 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:38354 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757783Ab2HWRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:53:46 -0400
Message-ID: <50366E24.9040500@xenotime.net>
Date: Thu, 23 Aug 2012 10:53:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: bus: omap-ocp2scp: Fix compile error
References: <1345743626-28364-1-git-send-email-kishon@ti.com>
In-Reply-To: <1345743626-28364-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 10:40 AM, Kishon Vijay Abraham I wrote:

> Fixes
> CC [M]  drivers/bus/omap-ocp2scp.o
> drivers/bus/omap-ocp2scp.c:70:1: error: '__mod_of_device_table' aliased to
> undefined symbol 'omap_usb2_id_table'
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/bus/omap-ocp2scp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
> index 9075ef8..ff63560 100644
> --- a/drivers/bus/omap-ocp2scp.c
> +++ b/drivers/bus/omap-ocp2scp.c
> @@ -67,7 +67,7 @@ static const struct of_device_id omap_ocp2scp_id_table[] = {
>  	{ .compatible = "ti,omap-ocp2scp" },
>  	{}
>  };
> -MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
> +MODULE_DEVICE_TABLE(of, omap_ocp2scp_id_table);
>  #endif
>  
>  static struct platform_driver omap_ocp2scp_driver = {



-- 
~Randy
