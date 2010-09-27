Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab0I0Byt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 21:54:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43123
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758728Ab0I0Byr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 21:54:47 -0400
Date: Sun, 26 Sep 2010 18:55:06 -0700 (PDT)
Message-Id: <20100926.185506.116382972.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, tj@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] rionet: use free_netdev(netdev) instead of kfree()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285495083-21899-1-git-send-email-segooon@gmail.com>
References: <1285495083-21899-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 26 Sep 2010 13:58:03 +0400

> Freeing netdev without free_netdev() leads to net, tx leaks.
> I might lead to dereferencing freed pointer.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> @@
> struct net_device* dev;
> @@
> 
> -kfree(dev)
> +free_netdev(dev)

Applied.
