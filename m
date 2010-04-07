Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0DGRyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:54:16 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:60805 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0DGRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:54:15 -0400
Date: Wed, 7 Apr 2010 10:50:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       netdev <netdev@vger.kernel.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 7 (net/core/dev_addr_lists)
Message-Id: <20100407105049.0f812b27.randy.dunlap@oracle.com>
In-Reply-To: <1270661889.8141.45.camel@edumazet-laptop>
References: <20100407174123.81b32310.sfr@canb.auug.org.au>
	<20100407095845.f29ebf48.randy.dunlap@oracle.com>
	<1270661889.8141.45.camel@edumazet-laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BBCC5FF.00C6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Apr 2010 19:38:09 +0200 Eric Dumazet wrote:

> [PATCH net-next-2.6] net: include linux/proc_fs.h in dev_addr_lists.c
> 
> As pointed by Randy Dunlap, we must include linux/proc_fs.h in
> net/core/dev_addr_lists.c, regardless of CONFIG_PROC_FS
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>, 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Eric.


> ---
> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index 37d5975..508f9c1 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c
> @@ -14,6 +14,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/list.h>
> +#include <linux/proc_fs.h>
>  
>  /*
>   * General list handling functions
> @@ -667,7 +668,6 @@ void dev_mc_init(struct net_device *dev)
>  EXPORT_SYMBOL(dev_mc_init);
>  
>  #ifdef CONFIG_PROC_FS
> -#include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  
>  static int dev_mc_seq_show(struct seq_file *seq, void *v)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
