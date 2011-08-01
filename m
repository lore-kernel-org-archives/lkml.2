Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1HAJeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:34:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1HAJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:33:53 -0400
Date: Mon, 01 Aug 2011 02:27:52 -0700 (PDT)
Message-Id: <20110801.022752.1007506557598017442.davem@davemloft.net>
To: julia@diku.dk
Cc: kernel-janitors@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] net: adjust array index
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311857165-14780-2-git-send-email-julia@diku.dk>
References: <1311857165-14780-1-git-send-email-julia@diku.dk>
	<1311857165-14780-2-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 01 Aug 2011 02:27:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 28 Jul 2011 14:46:01 +0200

> From: Julia Lawall <julia@diku.dk>
> 
> Convert array index from the loop bound to the loop index.
> 
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e1,e2,ar;
> @@
> 
> for(e1 = 0; e1 < e2; e1++) { <...
>   ar[
> - e2
> + e1
>   ]
>   ...> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
