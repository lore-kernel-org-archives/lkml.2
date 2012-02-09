Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2BIIZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:25:23 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:65505 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2BIIZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:25:21 -0500
Message-ID: <4F3382CF.8090302@atmel.com>
Date: Thu, 09 Feb 2012 09:24:47 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH 09/50] Cadence MACB: use dev_hw_addr_random() instead
 of random_ether_addr()
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <1328735457-29986-10-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1328735457-29986-10-git-send-email-danny.kukawka@bisect.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 10:10 PM, Danny Kukawka :
> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Danny,

You can add my "Acked-by" even if you rework this series...

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, best regards,

> ---
>  drivers/net/ethernet/cadence/macb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 2320068..3ee8d79 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -87,7 +87,7 @@ static void __init macb_get_hwaddr(struct macb *bp)
>  		memcpy(bp->dev->dev_addr, addr, sizeof(addr));
>  	} else {
>  		netdev_info(bp->dev, "invalid hw address, using random\n");
> -		random_ether_addr(bp->dev->dev_addr);
> +		dev_hw_addr_random(bp->dev, bp->dev->dev_addr);
>  	}
>  }
>  


-- 
Nicolas Ferre
