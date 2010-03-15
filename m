Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937005Ab0COWrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:47:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34465
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932386Ab0COWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:46:54 -0400
Date: Mon, 15 Mar 2010 15:47:14 -0700 (PDT)
Message-Id: <20100315.154714.23695928.davem@davemloft.net>
To: julia@diku.dk
Cc: ram.vepa@neterion.com, santosh.rastapur@neterion.com,
       sivakumar.subramani@neterion.com, sreenivasa.honnur@neterion.com,
       anil.murthy@neterion.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/net: drop redundant memset
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1003092213500.4974@ask.diku.dk>
References: <Pine.LNX.4.64.1003092213500.4974@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 9 Mar 2010 22:14:11 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> The region set by the call to memset is immediately overwritten by the
> subsequent call to memcpy.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e1,e2,e3,e4;
> @@
> 
> - memset(e1,e2,e3);
>   memcpy(e1,e4,e3);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks!
