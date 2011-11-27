Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1K0WQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 17:16:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47341 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1K0WQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 17:16:23 -0500
Date: Sun, 27 Nov 2011 17:15:05 -0500 (EST)
Message-Id: <20111127.171505.133514253141034705.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, ppopov@mvista.com, graf.yang@analog.com,
        kuninori.morimoto.gx@renesas.com, samuel@sortiz.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/irda: convert drivers/net/irda/* to use
 module_platform_driver()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322402885.2746.1.camel@phoenix>
References: <1322402885.2746.1.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 27 Nov 2011 14:15:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 27 Nov 2011 22:08:05 +0800

> This patch converts the drivers in drivers/net/irda/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Pete Popov <ppopov@mvista.com>
> Cc: Graf Yang <graf.yang@analog.com>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

This doesn't apply cleanly to the net-next tree, please respin.
