Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1DTUYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:24:30 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:6968 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1DTUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:24:29 -0400
Message-ID: <4DAF40EB.20303@chelsio.com>
Date: Wed, 20 Apr 2011 13:24:11 -0700
From: Dimitris Michailidis <dm@chelsio.com>
Organization: Chelsio Communications
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/8] Add a new zerocopy device flag
References: <1303328216.19336.18.camel@localhost.localdomain>	 <1303328648.19336.24.camel@localhost.localdomain>	 <1303328906.2823.24.camel@bwh-desktop> <1303330173.19336.52.camel@localhost.localdomain>
In-Reply-To: <1303330173.19336.52.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 01:09 PM, Shirley Ma wrote:
> Resubmit this patch with the new bit.

Bit 30 is also taken in net-next.

> 
> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> ---
> 
>  include/linux/netdevice.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 0249fe7..0998d3d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1067,6 +1067,9 @@ struct net_device {
>  #define NETIF_F_RXHASH		(1 << 28) /* Receive hashing offload */
>  #define NETIF_F_RXCSUM		(1 << 29) /* Receive checksumming offload */
>  
> +/* Bit 30 is for device to map userspace buffers -- zerocopy */
> +#define NETIF_F_ZEROCOPY	(1 << 30)
> +
>  	/* Segmentation offload features */
>  #define NETIF_F_GSO_SHIFT	16
>  #define NETIF_F_GSO_MASK	0x00ff0000
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

