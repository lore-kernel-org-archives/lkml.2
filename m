Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0JDFGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 01:06:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37757
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586Ab0JDFGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 01:06:05 -0400
Date: Sun, 03 Oct 2010 22:06:25 -0700 (PDT)
Message-Id: <20101003.220625.260083752.davem@davemloft.net>
To: julia@diku.dk
Cc: wharms@bfs.de, chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/atm/idt77252.c: Remove unnecessary error
 check
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1010021636330.21879@ask.diku.dk>
References: <1286027958-7333-4-git-send-email-julia@diku.dk>
	<4CA73D26.7090109@bfs.de>
	<Pine.LNX.4.64.1010021636330.21879@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 2 Oct 2010 16:37:07 +0200 (CEST)

> This code does not call deinit_card(card); in an error case, as done in
> other error-handling code in the same function.  But actually, the called
> function init_sram can only return 0, so there is no need for the error
> check at all.
> 
> init_sram is also given a void return type, and its single return statement
> at the end of the function is dropped.
> 
> A simplified version of the sematic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thank you.
