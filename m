Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2HOABW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:01:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39910 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2HOABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:01:20 -0400
Date: Tue, 14 Aug 2012 17:01:19 -0700 (PDT)
Message-Id: <20120814.170119.1578623634371862790.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/net/ethernet/mellanox/mlx4/mcg.c: fix
 error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344949115-13266-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1344949115-13266-1-git-send-email-Julia.Lawall@lip6.fr>
	<1344949115-13266-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Tue, 14 Aug 2012 14:58:34 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a 0 error return code to a negative one, as returned elsewhere in the
> function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
