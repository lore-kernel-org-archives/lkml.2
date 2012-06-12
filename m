Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2FLADi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:03:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47080 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2FLADh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:03:37 -0400
Date: Mon, 11 Jun 2012 17:03:36 -0700 (PDT)
Message-Id: <20120611.170336.1197560839526564340.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: eric.dumazet@gmail.com, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v10] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <201206072045.q57Kj2r1009249@farm-0002.internal.tilera.com>
References: <4FCFA312.4020505@tilera.com>
	<20120606.115440.1245419453265419850.davem@davemloft.net>
	<201206072045.q57Kj2r1009249@farm-0002.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 7 Jun 2012 16:45:02 -0400

> This change adds support for the tilegx network driver based on the
> GXIO IORPC support in the tilegx software stack, using the on-chip
> mPIPE packet processing engine.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Applied.

Although:

> +/* The transmit wake timer for a given cpu and echannel. */
> +struct tile_net_tx_wake {
> +	struct hrtimer timer;
> +	struct net_device *dev;
> +};
> +	
   ^^^^^^^

I had to remove that trailing whitespace when I applied this.
