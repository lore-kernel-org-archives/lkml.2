Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2HOABM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:01:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39903 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2HOABK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:01:10 -0400
Date: Tue, 14 Aug 2012 17:01:09 -0700 (PDT)
Message-Id: <20120814.170109.2145761320842984364.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: pantelis.antoniou@gmail.com, kernel-janitors@vger.kernel.org,
        vbordug@ru.mvista.com, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/net/ethernet/freescale/fs_enet: fix error
 return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344949115-13266-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1344949115-13266-1-git-send-email-Julia.Lawall@lip6.fr>
	<1344949115-13266-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Tue, 14 Aug 2012 14:58:33 +0200

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

