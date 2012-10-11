Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab2JKTVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:21:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38864 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab2JKTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:20:59 -0400
Date: Thu, 11 Oct 2012 15:20:57 -0400 (EDT)
Message-Id: <20121011.152057.418629873945363485.davem@davemloft.net>
To: joe@perches.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brian.haley@hp.com
Subject: Re: [PATCH net-next? V2] pktgen: Use simpler test for non-zero
 ipv6 address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349897005.2035.24.camel@joe-AO722>
References: <1349894559.2035.12.camel@joe-AO722>
	<1349895710.21172.7235.camel@edumazet-glaptop>
	<1349897005.2035.24.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 10 Oct 2012 12:23:25 -0700

> Reduces object size and should be slightly faster.
> 
> allyesconfig: 
> $ size net/core/pktgen.o*
>    text	   data	    bss	    dec	    hex	filename
>   52284	   4321	  11840	  68445	  10b5d	net/core/pktgen.o.new
>   52310	   4293	  11848	  68451	  10b63	net/core/pktgen.o.old
>  
> Signed-off-by: Joe Perches <joe@perches.com>

Please resubmit when net-next opens.
