Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab1FBHLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:11:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56767 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1FBHLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:11:16 -0400
Date: Thu, 02 Jun 2011 00:10:59 -0700 (PDT)
Message-Id: <20110602.001059.183111215741236866.davem@davemloft.net>
To: julia@diku.dk
Cc: joe@perches.com, wg@grandegger.com, kernel-janitors@vger.kernel.org,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wharms@bfs.de
Subject: Re: [PATCH 4/10] drivers/net/can/flexcan.c: add missing clk_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1106020748020.22932@ask.diku.dk>
References: <Pine.LNX.4.64.1106012207260.5871@ask.diku.dk>
	<20110601.131136.391831410750786951.davem@davemloft.net>
	<Pine.LNX.4.64.1106020748020.22932@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Jun 2011 00:11:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 2 Jun 2011 07:48:50 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> The failed_get label is used after the call to clk_get has succeeded, so it
> should be moved up above the call to clk_put.
> 
> The failed_req labels doesn't do anything different than failed_get, so
> delete it.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
