Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2HGVqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 17:46:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60623 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2HGVqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 17:46:10 -0400
Date: Tue, 07 Aug 2012 14:46:09 -0700 (PDT)
Message-Id: <20120807.144609.956779270587698041.davem@davemloft.net>
To: ahiliation@yahoo.co.in
Cc: acme@ghostprotocols.net, bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net:appletalk:ddp:fixed coding style issue again
 relating to
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344348020-4966-1-git-send-email-ahiliation@yahoo.co.in>
References: <1344348020-4966-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Tue,  7 Aug 2012 19:30:20 +0530

> Fixed coding style issue relating to indentation in
> net/appletalk/ddp.c found by checkpatch.pl tool
> 
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

Please just stop trying to fix this code up, it's noise and you
keep making mistakes.

>  	case TIOCOUTQ: {
> -			long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
> +		long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
>  
> -			if (amount < 0)
> -				amount = 0;
> -			rc = put_user(amount, (int __user *)argp);
> -			break;
> +		if (amount < 0)
> +			amount = 0;
> +		rc = put_user(amount, (int __user *)argp);
> +		break;
>  		}

This time you didn't adjust the closing brace, as needed.

I'm not applying this and I seriously discourage you from pursing this
further, it's better you spend your time learning how the kernel works
rather than suffering through this coding style cleanup business.

Thanks.
