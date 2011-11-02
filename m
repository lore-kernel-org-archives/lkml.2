Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1KBFwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 01:52:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48138 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1KBFwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 01:52:15 -0400
Date: Wed, 02 Nov 2011 01:50:04 -0400 (EDT)
Message-Id: <20111102.015004.118482982480965571.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111102163708.75d719e765dea20e0c4c5a04@canb.auug.org.au>
References: <20111102163708.75d719e765dea20e0c4c5a04@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 01 Nov 2011 22:50:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 2 Nov 2011 16:37:08 +1100

> Subject: [PATCH] net: fix typo in drivers/net/ethernet/xilinx/ll_temac_main.c
> 
> Commit 9e903e085262 ("net: add skb frag size accessors") used frag_size
> instead of skb_frag_size in this file.
> 
> Fixes this build error:
> 
> drivers/net/ethernet/xilinx/ll_temac_main.c: In function 'temac_start_xmit':
> drivers/net/ethernet/xilinx/ll_temac_main.c:717:3: error: implicit declaration of function 'frag_size' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks!
