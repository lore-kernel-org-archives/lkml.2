Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2IYHL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:11:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58664 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2IYHL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:11:57 -0400
Date: Tue, 25 Sep 2012 03:11:53 -0400 (EDT)
Message-Id: <20120925.031153.2084805663532004378.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: raw: revert unrelated change
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348554076.26828.1990.camel@edumazet-glaptop>
References: <20120925.011343.1495275645575636949.davem@davemloft.net>
	<1348550602.26828.1918.camel@edumazet-glaptop>
	<1348554076.26828.1990.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 25 Sep 2012 08:21:16 +0200

> From: Eric Dumazet <edumazet@google.com>
> 
> Commit 5640f7685831 ("net: use a per task frag allocator")
> accidentally contained an unrelated change to net/ipv4/raw.c,
> later committed (without the pr_err() debugging bits) in
> net tree as commit ab43ed8b749 (ipv4: raw: fix icmp_filter())
> 
> This patch reverts this glitch, noticed by Stephen Rothwell.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
