Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab2IGXmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:42:53 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46952 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758638Ab2IGXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:42:50 -0400
Message-ID: <504A8662.9050907@xenotime.net>
Date: Fri, 07 Sep 2012 16:42:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH][v2] netdev/phy: mdio-mux-mmioreg.c should include of_address.h
References: <1347053457-24935-1-git-send-email-timur@freescale.com>
In-Reply-To: <1347053457-24935-1-git-send-email-timur@freescale.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 02:30 PM, Timur Tabi wrote:

> mdio-mux-mmioreg.c uses function of_address_to_resource(), which is defined
> in linux/of_address.h.  This fixes a compilation error:
> 
> drivers/net/phy/mdio-mux-mmioreg.c: In function 'mdio_mux_mmioreg_probe':
> drivers/net/phy/mdio-mux-mmioreg.c:83:2: error: implicit declaration of
> 	function 'of_address_to_resource'
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> 


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/net/phy/mdio-mux-mmioreg.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-mux-mmioreg.c b/drivers/net/phy/mdio-mux-mmioreg.c
> index 098239a..9061ba6 100644
> --- a/drivers/net/phy/mdio-mux-mmioreg.c
> +++ b/drivers/net/phy/mdio-mux-mmioreg.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/platform_device.h>
>  #include <linux/device.h>
> +#include <linux/of_address.h>
>  #include <linux/of_mdio.h>
>  #include <linux/module.h>
>  #include <linux/init.h>



-- 
~Randy
