Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2HFU2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:28:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38877 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2HFU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:28:36 -0400
Date: Mon, 06 Aug 2012 13:28:35 -0700 (PDT)
Message-Id: <20120806.132835.1454407216893349784.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] drivers/net/phy/mdio-mux-gpio.c: drop devm_kfree
 of devm_kzalloc'd data
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344099049-15212-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1344099049-15212-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sat,  4 Aug 2012 18:50:49 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> devm_kfree should not have to be explicitly used.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,d;
> @@
> 
> x = devm_kzalloc(...)
> ...
> ?-devm_kfree(d,x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
