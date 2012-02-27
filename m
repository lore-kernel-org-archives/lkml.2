Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2B0EHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:07:50 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56187 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2B0EHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:07:48 -0500
Date: Sun, 26 Feb 2012 23:05:23 -0500 (EST)
Message-Id: <20120226.230523.1906949835561978402.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120227121125.007c32f9aa7be2470d9e3356@canb.auug.org.au>
References: <20120227121125.007c32f9aa7be2470d9e3356@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 26 Feb 2012 20:05:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Feb 2012 12:11:25 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/sfc/rx.c between commit ff3bc1e75275 ("sfc: Fix
> assignment of ip_summed for pre-allocated skbs") from Linus' tree and
> commit db3395697cad ("sfc: Replace efx_rx_buffer::is_page and other
> booleans with a flags field") from the net-next tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

I just merged net into net-next and resolved this conflict.

Thanks!
