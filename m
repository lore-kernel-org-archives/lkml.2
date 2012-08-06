Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2HFTEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:04:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38031 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2HFTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:03:59 -0400
Date: Mon, 06 Aug 2012 12:03:59 -0700 (PDT)
Message-Id: <20120806.120359.747789694625389454.davem@davemloft.net>
To: ahiliation@yahoo.co.in
Cc: acme@ghostprotocols.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net:appletalk:ddp:fixed coding style issue relating to
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344274298-4711-1-git-send-email-ahiliation@yahoo.co.in>
References: <1344274298-4711-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Mon,  6 Aug 2012 23:01:38 +0530

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

Only moving the case statement back one TAB and but not any of the
surrounding code is utterly rediculous.

This is why we hate purely coding style fixing patches.
