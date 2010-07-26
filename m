Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0GZFDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:03:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33530
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045Ab0GZFDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:03:23 -0400
Date: Sun, 25 Jul 2010 22:03:40 -0700 (PDT)
Message-Id: <20100725.220340.115945473.davem@davemloft.net>
To: joe@perches.com
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/qla3xxx.c: Update logging message
 style
From: David Miller <davem@davemloft.net>
In-Reply-To: <4057a685dc2c277e9e3137c4f0e01eeb389971a4.1279837596.git.joe@perches.com>
References: <4057a685dc2c277e9e3137c4f0e01eeb389971a4.1279837596.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 22 Jul 2010 15:33:31 -0700

> Use pr_<level>
> Use netdev_<level>
> Use netif_<level>
> Remove #define PFX
> Improve a couple of loops to avoid deep indentation.
> 
> Compile tested only
> 
> $ size drivers/net/qla3xxx.o.*
>    text    data     bss     dec     hex filename
>   51603     212   13864   65679   1008f drivers/net/qla3xxx.o.old
>   50413     212   13864   64489    fbe9 drivers/net/qla3xxx.o.new
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
