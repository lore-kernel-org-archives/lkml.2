Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0E2HTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 03:19:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38357
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032Ab0E2HTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 03:19:39 -0400
Date: Sat, 29 May 2010 00:19:50 -0700 (PDT)
Message-Id: <20100529.001950.71558279.davem@davemloft.net>
To: julia@diku.dk
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/17] drivers/isdn/hardware/mISDN: Add missing
 spin_unlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005261754560.23743@ask.diku.dk>
References: <Pine.LNX.4.64.1005261754560.23743@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Wed, 26 May 2010 17:55:10 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> Add a spin_unlock missing on the error path.  The return value of write_reg
> seems to be completely ignored, so it seems that the lock should be
> released in every case.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.
