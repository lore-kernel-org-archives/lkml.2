Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0J0TXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:23:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42110
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656Ab0J0TXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:23:20 -0400
Date: Wed, 27 Oct 2010 12:23:43 -0700 (PDT)
Message-Id: <20101027.122343.68121252.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/14] drivers/net/sb1000.c: delete double assignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288088743-3725-6-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
	<1288088743-3725-6-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 26 Oct 2010 12:25:34 +0200

> From: Julia Lawall <julia@diku.dk>
> 
> The other code around these duplicated assignments initializes the 0 1 2
> and 3 elements of an array, so change the initialization of the
> rx_session_id array to do the same.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
