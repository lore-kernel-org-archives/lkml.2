Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935397Ab0GPCHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:07:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49874
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935383Ab0GPCHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:07:18 -0400
Date: Thu, 15 Jul 2010 19:07:34 -0700 (PDT)
Message-Id: <20100715.190734.245390906.davem@davemloft.net>
To: joe@perches.com
Cc: rolandd@cisco.com, yevgenyp@mellanox.co.il, jackm@dev.mellanox.co.il,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/mlx4: Use %pV, pr_<level>,
 printk_once
From: David Miller <davem@davemloft.net>
In-Reply-To: <baf5f3949ffd5a48a6f5667b6d6394e6d48c91ca.1278696312.git.joe@perches.com>
References: <baf5f3949ffd5a48a6f5667b6d6394e6d48c91ca.1278696312.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 10 Jul 2010 10:22:46 -0700

> Remove near duplication of format string constants by using the newly
> introduced vsprintf extention %pV to reduce text by 20k or so.
> 
> $ size drivers/net/mlx4/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  161367	   1866	  48784	 212017	  33c31	drivers/net/mlx4/built-in.o
>  142621	   1866	  46248	 190735	  2e90f	drivers/net/mlx4/built-in.o.new
> 
> Use printk_once as appropriate.
> Convert printks to pr_<level>, some bare printks now use pr_cont.
> Remove now unused #define PFX.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
