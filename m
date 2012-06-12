Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2FLWwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:52:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2FLWwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:52:19 -0400
Date: Tue, 12 Jun 2012 15:52:18 -0700 (PDT)
Message-Id: <20120612.155218.1712141231523216893.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH 1/7] drivers/ide/ide-cs.c: adjust suspicious bit
 operation
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1206121016090.1795@hadrien>
References: <alpine.DEB.2.02.1206080712510.1793@hadrien>
	<20120611.164316.2252454788889367611.davem@davemloft.net>
	<alpine.DEB.2.02.1206121016090.1795@hadrien>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Tue, 12 Jun 2012 10:17:25 -0400 (EDT)

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> IO_DATA_PATH_WIDTH_8 is 0, so a bit-and with it is always false.  The
> value IO_DATA_PATH_WIDTH covers the bits of the IO_DATA_PATH constants, so
> first pick those bits and then make the test using !=.
> 
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thanks.
