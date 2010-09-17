Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0IQFAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:00:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42375
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab0IQFAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:00:40 -0400
Date: Thu, 16 Sep 2010 22:00:59 -0700 (PDT)
Message-Id: <20100916.220059.215549902.davem@davemloft.net>
To: chris.snook@gmail.com
Cc: akpm@linux-foundation.org, joe@perches.com, linux-kernel@vger.kernel.org,
        atl1-devel@lists.sourceforge.net, jcliburn@gmail.com,
        jie.yang@atheros.com, netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: move atlx discussions to netdev
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100916210830.GB25481@fourier.jnsq.org>
References: <20100916210830.GB25481@fourier.jnsq.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <chris.snook@gmail.com>
Date: Thu, 16 Sep 2010 17:08:30 -0400

> From: Chris Snook <chris.snook@gmail.com>
> 
> The atlx drivers are sufficiently mature that we no longer need a separate
> mailing list for them.  Move the discussion to netdev, so we can decommission
> atl1-devel, which is now mostly spam.
> 
> Signed-off-by: Chris Snook <chris.snook@gmail.com>

Applied, please CC: netdev on networking MAINTAINER patches in the future.

Thanks.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index e7c528f..8e904c8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1135,7 +1135,7 @@ ATLX ETHERNET DRIVERS
>  M:	Jay Cliburn <jcliburn@gmail.com>
>  M:	Chris Snook <chris.snook@gmail.com>
>  M:	Jie Yang <jie.yang@atheros.com>
> -L:	atl1-devel@lists.sourceforge.net
> +L:	netdev@vger.kernel.org
>  W:	http://sourceforge.net/projects/atl1
>  W:	http://atl1.sourceforge.net
>  S:	Maintained
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
