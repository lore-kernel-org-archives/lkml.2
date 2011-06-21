Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1FUXEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:04:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab1FUXEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:04:48 -0400
Date: Tue, 21 Jun 2011 16:03:34 -0700 (PDT)
Message-Id: <20110621.160334.1438754754048406782.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, coreteam@netfilter.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        xeb@mail.ru
Subject: Re: [PATCH] Remove redundant linux/version.h includes from net/
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1106210009520.27735@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106210009520.27735@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Jun 2011 16:03:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Tue, 21 Jun 2011 00:13:10 +0200 (CEST)

> It was suggested by "make versioncheck" that the follwing includes of
> linux/version.h are redundant:
> 
>   /home/jj/src/linux-2.6/net/caif/caif_dev.c: 14 linux/version.h not needed.
>   /home/jj/src/linux-2.6/net/caif/chnl_net.c: 10 linux/version.h not needed.
>   /home/jj/src/linux-2.6/net/ipv4/gre.c: 19 linux/version.h not needed.
>   /home/jj/src/linux-2.6/net/netfilter/ipset/ip_set_core.c: 20 linux/version.h not needed.
>   /home/jj/src/linux-2.6/net/netfilter/xt_set.c: 16 linux/version.h not needed.
> 
> and it seems that it is right.
> 
> Beyond manually inspecting the source files I also did a few build
> tests with various configs to confirm that including the header in
> those files is indeed not needed.
> 
> Here's a patch to remove the pointless includes.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks.
