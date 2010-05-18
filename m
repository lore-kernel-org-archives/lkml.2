Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0ERFza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:55:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56000
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568Ab0ERFz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:55:28 -0400
Date: Mon, 17 May 2010 22:55:37 -0700 (PDT)
Message-Id: <20100517.225537.35834177.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 13/20] net/caif: Use kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005132203150.6282@ask.diku.dk>
References: <Pine.LNX.4.64.1005132203150.6282@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 13 May 2010 22:03:32 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> Use kzalloc rather than the combination of kmalloc and memset.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,size,flags;
> statement S;
> @@
> 
> -x = kmalloc(size,flags);
> +x = kzalloc(size,flags);
>  if (x == NULL) S
> -memset(x, 0, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
