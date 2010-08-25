Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0HYXhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:37:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59316
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963Ab0HYXhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:31 -0400
Date: Wed, 25 Aug 2010 16:37:46 -0700 (PDT)
Message-Id: <20100825.163746.15256125.davem@davemloft.net>
To: julia@diku.dk
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/net/irda: Eliminate memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1008241638130.15172@ask.diku.dk>
References: <Pine.LNX.4.64.1008241638130.15172@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 24 Aug 2010 16:38:33 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> dev_alloc_skb allocates some memory, so that memory should be freed before
> leaving the function in an error case.
> 
> Corrected some typos in a nearby comment as well.
> 
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
