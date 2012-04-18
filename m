Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2DRCeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:34:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:32871 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2DRCeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:34:21 -0400
Date: Tue, 17 Apr 2012 22:33:07 -0400 (EDT)
Message-Id: <20120417.223307.693772402010148380.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: kevin.curtis@farsite.co.uk, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wan/farsync.c: add missing iounmap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334589732-25876-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1334589732-25876-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Apr 2012 19:33:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon, 16 Apr 2012 17:22:12 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Free card->mem in the error-handling code since it was successfully
> allocated just above.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thanks Julia.
