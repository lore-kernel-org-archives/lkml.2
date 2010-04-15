Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0DOSvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:51:23 -0400
Received: from katalix.com ([82.103.140.233]:40570 "EHLO mail.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab0DOSvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:51:21 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 14:51:21 EDT
Message-ID: <4BC75EA3.2070402@katalix.com>
Date: Thu, 15 Apr 2010 19:44:51 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/l2tp/l2tp_debugfs.c: Convert NIPQUAD to
 %pI4
References: <1271349703.1726.62.camel@Joe-Laptop.home>
In-Reply-To: <1271349703.1726.62.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: James Chapman <jchapman@katalix.com>

> ---
>  net/l2tp/l2tp_debugfs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
> index 908f10f..104ec3b 100644
> --- a/net/l2tp/l2tp_debugfs.c
> +++ b/net/l2tp/l2tp_debugfs.c
> @@ -122,8 +122,8 @@ static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
>  	seq_printf(m, "\nTUNNEL %u peer %u", tunnel->tunnel_id, tunnel->peer_tunnel_id);
>  	if (tunnel->sock) {
>  		struct inet_sock *inet = inet_sk(tunnel->sock);
> -		seq_printf(m, " from " NIPQUAD_FMT " to " NIPQUAD_FMT "\n",
> -			   NIPQUAD(inet->inet_saddr), NIPQUAD(inet->inet_daddr));
> +		seq_printf(m, " from %pI4 to %pI4\n",
> +			   &inet->inet_saddr, &inet->inet_daddr);
>  		if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
>  			seq_printf(m, " source port %hu, dest port %hu\n",
>  				   ntohs(inet->inet_sport), ntohs(inet->inet_dport));
> 
> 
> 

