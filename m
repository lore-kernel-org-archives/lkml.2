Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0HAHcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 03:32:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48693
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab0HAHcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 03:32:21 -0400
Date: Sun, 01 Aug 2010 00:32:39 -0700 (PDT)
Message-Id: <20100801.003239.258116208.davem@davemloft.net>
To: julia@diku.dk
Cc: ralf@linux-mips.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/rose: Use GFP_ATOMIC
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1007311156180.6434@ask.diku.dk>
References: <Pine.LNX.4.64.1007311156180.6434@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 31 Jul 2010 11:56:39 +0200 (CEST)

> The other calls to kmalloc in the same function use GFP_ATOMIC, and indeed
> two locks are held within the body of the function.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thank you!
