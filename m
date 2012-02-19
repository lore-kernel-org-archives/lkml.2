Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2BTACw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:02:52 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40666 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BTACu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:02:50 -0500
Date: Sun, 19 Feb 2012 18:58:32 -0500 (EST)
Message-Id: <20120219.185832.570250355385915096.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/atm/solos-pci.c: exchange pci_iounmaps
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329680612-28055-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1329680612-28055-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 15:58:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sun, 19 Feb 2012 20:43:32 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The calls to pci_iounmap are in the wrong order, as compared to the
> associated calls to pci_iomap.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Good catch, applied.
