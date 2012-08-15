Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2HOAAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:00:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2HOAAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:00:11 -0400
Date: Tue, 14 Aug 2012 17:00:10 -0700 (PDT)
Message-Id: <20120814.170010.1136116037664193225.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/net/ethernet/ti/davinci_cpdma.c: Remove
 potential NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344959388-19719-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
	<1344959388-19719-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Tue, 14 Aug 2012 17:49:47 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> If the NULL test is necessary, the initialization involving a dereference of
> the tested value should be moved after the NULL test.
> 
> The sematic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thanks.
