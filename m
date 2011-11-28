Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1K1Bav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:30:51 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48368 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1K1Bau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:30:50 -0500
Date: Sun, 27 Nov 2011 20:29:25 -0500 (EST)
Message-Id: <20111127.202925.1652888847828501280.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        samuel@sortiz.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net/irda: convert drivers/net/irda/* to use
 module_platform_driver()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322443443.2408.0.camel@phoenix>
References: <1322443443.2408.0.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 27 Nov 2011 17:29:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 28 Nov 2011 09:24:03 +0800

> This patch converts the drivers in drivers/net/irda/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> v2: re-generate the patch against net-next tree.

Applied, thanks a lot.
