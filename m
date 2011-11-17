Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1KQBhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:37:38 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37044 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1KQBhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:37:36 -0500
Date: Wed, 16 Nov 2011 20:35:27 -0500 (EST)
Message-Id: <20111116.203527.1216342714272524865.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] Use ETH_ALEN
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1321472142.git.joe@perches.com>
References: <cover.1321472142.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 16 Nov 2011 17:35:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 16 Nov 2011 11:38:01 -0800

> Remove other #defines and uses in favor of ETH_ALEN
> 
> Joe Perches (5):
>   ethernet: Convert MAC_ADDR_LEN uses to ETH_ALEN
>   ethernet: Convert ETHER_ADDR_LEN uses to ETH_ALEN
>   bna: Convert MAC_ADDRLEN uses to ETH_ALEN
>   amd8111e:  Convert ETH_ADDR_LEN uses to ETH_ALEN
>   ucc_geth: Convert ENET_NUM_OCTETS_PER_ADDRESS uses to ETH_ALEN

All applied, thanks Joe.
