Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2CKWps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 18:45:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41841 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2CKWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 18:45:41 -0400
Date: Sun, 11 Mar 2012 15:42:26 -0700 (PDT)
Message-Id: <20120311.154226.1278106806584648233.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: samuel@sortiz.org, kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7]
 drivers/net/irda/{ali-ircc,via-ircc,w83977af-ir}.c: ensure arguments to
 request_irq and free_irq are compatible
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331502542-18094-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1331502542-18094-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 11 Mar 2012 15:42:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sun, 11 Mar 2012 22:49:02 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert calls to free_irq so that the second argument is the same as the
> last argument of the corresponding call to request_irq.  Without this
> property, free_irq does nothing.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
