Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0K2Tvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:51:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42034
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756Ab0K2Tvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:32 -0500
Date: Mon, 29 Nov 2010 11:51:57 -0800 (PST)
Message-Id: <20101129.115157.246510826.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, bhutchings@solarflare.com, szymon@janc.net.pl,
        mirqus@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] forcedeth: Convert to use netdev_<level> and
 neatening
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1291051316.git.joe@perches.com>
References: <cover.1291051316.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 29 Nov 2010 09:41:51 -0800

> Some mild restructuring and some generally neatening.
> 
> The conversions of dprintk to netdev_dbg in patches 2 and 4 are
> deleted in patch 10 as these seem to have been used only
> during initial development and are not normally compiled-in.
> 
> Patch 10 may be ignored if desired.
> 
> Object size is reduced ~2Kb overall.
> 
> $ size drivers/net/forcedeth.o.*
>    text	   data	    bss	    dec	    hex	filename
>   71739	    336	  17176	  89251	  15ca3	drivers/net/forcedeth.o.new
>   73416	    240	  17696	  91352	  164d8	drivers/net/forcedeth.o.old

These look fine, applied, thanks.
