Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab2IEVqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:46:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45041 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2IEVqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:46:39 -0400
Date: Wed, 05 Sep 2012 17:46:37 -0400 (EDT)
Message-Id: <20120905.174637.1499279266416363296.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120905153932.eebf343364800678aecc98f2@canb.auug.org.au>
References: <20120905153932.eebf343364800678aecc98f2@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 5 Sep 2012 15:39:32 +1000

> (I always thought IPv6 NAT was a bad idea ;-))

ROFL :)

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 5 Sep 2012 15:34:58 +1000
> Subject: [PATCH] netfilter: ipv6: using csum_ipv6_magic requires
>  net/ip6_checksum.h
> 
> Fixes this build error:
> 
> net/ipv6/netfilter/nf_nat_l3proto_ipv6.c: In function 'nf_nat_ipv6_csum_recalc':
> net/ipv6/netfilter/nf_nat_l3proto_ipv6.c:144:4: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks Stephen.
