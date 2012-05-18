Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab2ERV4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:56:21 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54743 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab2ERV4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:56:20 -0400
Date: Fri, 18 May 2012 14:56:17 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]net:ethernet:fixed a coding style issue relating
 space.
Message-ID: <20120518145617.710bc1d6@nehalam.linuxnetplumber.net>
In-Reply-To: <1337377537-4636-1-git-send-email-ahiliation@yahoo.co.in>
References: <1337377537-4636-1-git-send-email-ahiliation@yahoo.co.in>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 03:15:37 +0530
Jeffrin Jose <ahiliation@yahoo.co.in> wrote:

> Fixed a coding style issue relating to  space found
> by checkpatch.pl tool in net/ethernet/eth.c
> 
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
> ---
>  net/ethernet/eth.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index 36e5880..c847aa6 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -178,7 +178,7 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
>  	 *      seems to set IFF_PROMISC.
>  	 */
>  
> -	else if (1 /*dev->flags&IFF_PROMISC */ ) {
> +	else if (1 /*dev->flags&IFF_PROMISC */) {
>  		if (unlikely(!ether_addr_equal_64bits(eth->h_dest,
>  						      dev->dev_addr)))
>  			skb->pkt_type = PACKET_OTHERHOST;

Rather than put lips on a pig, why not remove the bogus if?
