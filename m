Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2G1O0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 10:26:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55409 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752387Ab2G1O0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 10:26:35 -0400
Message-ID: <1343485593.2009.8.camel@joe2Laptop>
Subject: Re: [PATCH] net:appletalk:ddp:fixed some codystyle issues in
From: Joe Perches <joe@perches.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: acme@ghostprotocols.net, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 28 Jul 2012 07:26:33 -0700
In-Reply-To: <1343472307-4697-1-git-send-email-ahiliation@yahoo.co.in>
References: <1343472307-4697-1-git-send-email-ahiliation@yahoo.co.in>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-28 at 16:15 +0530, Jeffrin Jose wrote:
> Fixed coding style issues relating to indentation found in
> net/appletalkddp.c."git diff -w" is empty and the compiled objects
> are the same too.

Hello Jeffrin.

Your commit message is OK but your patch not.

The switch/case that could use modification is at
line 1790, not at line 685.

> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
[]
> @@ -337,7 +337,7 @@ static int atif_proxy_probe_device(struct atalk_iface *atif,
>  
>  	return -EADDRINUSE;	/* Network is full... */
>  }
> -
> +   

Adding whitespace
 
>  struct atalk_addr *atalk_find_dev_addr(struct net_device *dev)
>  {
> @@ -685,26 +685,26 @@ static int atif_ioctl(int cmd, void __user *arg)
>  
>  	switch (cmd) {
>  	case SIOCSIFADDR:
> -		if (!capable(CAP_NET_ADMIN))
> +			if (!capable(CAP_NET_ADMIN))

There's nothing wrong here to fix and you are
adding incorrect indentation.

Please try again and make sure you verify your
proposed patches by using scripts/checkpatch.pl
before submitting them.

