Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2DRCv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:51:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33013 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2DRCv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:51:28 -0400
Date: Tue, 17 Apr 2012 22:50:18 -0400 (EDT)
Message-Id: <20120417.225018.2141913804796063004.davem@davemloft.net>
To: laura@rosedu.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH] ethernet: fix checkpatch errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334672844-10129-1-git-send-email-laura@rosedu.org>
References: <1334672844-10129-1-git-send-email-laura@rosedu.org>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Apr 2012 19:50:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Vasilescu <laura@rosedu.org>
Date: Tue, 17 Apr 2012 17:27:24 +0300

> Signed-off-by: Laura Vasilescu <laura@rosedu.org>

I'd rather have the checkpath errors than what we end up with
your changes:

> -	else if (1 /*dev->flags&IFF_PROMISC */ ) {
> -		if (unlikely(compare_ether_addr_64bits(eth->h_dest, dev->dev_addr)))
> +	else if (1 /*dev->flags&IFF_PROMISC */) {
> +		if (unlikely(compare_ether_addr_64bits(eth->h_dest,
> +							dev->dev_addr)))

This indentation is wrong, the "dev->dev_addr" argument must line up
with the first column after the openning parenthesis on the previous
line.

> -int eth_header_cache(const struct neighbour *neigh, struct hh_cache *hh, __be16 type)
> +int eth_header_cache(const struct neighbour *neigh,
> +			struct hh_cache *hh,
> +			__be16 type)

Same problem here for hh and type args.
