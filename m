Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2BBTj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:39:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44947 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab2BBTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:39:56 -0500
Date: Thu, 02 Feb 2012 14:37:49 -0500 (EST)
Message-Id: <20120202.143749.209790216360616297.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] drivers/net/ethernet/ti: Move call to PTR_ERR
 after reassignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328194382-32465-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1328194382-32465-1-git-send-email-Julia.Lawall@lip6.fr>
	<1328194382-32465-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Feb 2012 11:37:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Thu,  2 Feb 2012 15:53:01 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> PTR_ERR should be called before its argument is cleared.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Reported-by: Josh Triplett <josh@joshtriplett.org>

Applied, thanks.
