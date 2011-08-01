Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1HAJcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:32:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59838 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1HAJcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:32:16 -0400
Date: Mon, 01 Aug 2011 02:27:59 -0700 (PDT)
Message-Id: <20110801.022759.1366729474517785485.davem@davemloft.net>
To: julia@diku.dk
Cc: grant.likely@secretlab.ca, kernel-janitors@vger.kernel.org,
        bhutchings@solarflare.com, shemminger@vyatta.com,
        eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/6] drivers/net/niu.c: adjust array index
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311857165-14780-4-git-send-email-julia@diku.dk>
References: <1311857165-14780-1-git-send-email-julia@diku.dk>
	<1311857165-14780-4-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 01 Aug 2011 02:28:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 28 Jul 2011 14:46:03 +0200

> From: Julia Lawall <julia@diku.dk>
> 
> Convert array index from the loop bound to the loop index.
> 
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e1,e2,ar;
> @@
> 
> for(e1 = 0; e1 < e2; e1++) { <...
>   ar[
> - e2
> + e1
>   ]
>   ...> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
