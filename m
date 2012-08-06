Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab2HFR5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:57:35 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:9898 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756800Ab2HFR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:57:33 -0400
Message-ID: <1344275849.2632.28.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] net:appletalk:ddp:fixed coding style issue relating to
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
CC: <acme@ghostprotocols.net>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 6 Aug 2012 18:57:29 +0100
In-Reply-To: <1344274298-4711-1-git-send-email-ahiliation@yahoo.co.in>
References: <1344274298-4711-1-git-send-email-ahiliation@yahoo.co.in>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 23:01 +0530, Jeffrin Jose wrote:
> Fixed coding style issue relating to indentation
> in net/appletalk/ddp.c found by checkpatch.pl tool.
> 
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
> ---
>  net/appletalk/ddp.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
> index 8685296..4023fca 100644
> --- a/net/appletalk/ddp.c
> +++ b/net/appletalk/ddp.c
> @@ -1796,7 +1796,7 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  
>  	switch (cmd) {
>  		/* Protocol layer */
> -		case TIOCOUTQ: {
> +	case TIOCOUTQ: {
>  			long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
>  
>  			if (amount < 0)
[...]

The whole of the switch body should be shifted left by one tab, not just
the case-labels.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

