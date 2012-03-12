Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2CLGs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:48:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44402 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2CLGsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:48:51 -0400
Date: Sun, 11 Mar 2012 23:48:46 -0700 (PDT)
Message-Id: <20120311.234846.455580505379366792.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: Convert printks to pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331526971.13200.9.camel@joe2Laptop>
References: <1331526971.13200.9.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 11 Mar 2012 23:48:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 11 Mar 2012 21:36:11 -0700

> Use a more current kernel messaging style.
> 
> Convert a printk block to print_hex_dump.
> Coalesce formats, align arguments.
> Use %s, __func__ instead of embedding function names.
> 
> Some messages that were prefixed with <foo>_close are
> now prefixed with <foo>_fini.  Some ah4 and esp messages
> are now not prefixed with "ip ".
> 
> The intent of this patch is to later add something like
>   #define pr_fmt(fmt) "IPv4: " fmt.
> to standardize the output messages.
> 
> Text size is trivially reduced. (x86-32 allyesconfig)
> 
> $ size net/ipv4/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  887888	  31558	 249696	1169142	 11d6f6	net/ipv4/built-in.o.new
>  887934	  31558	 249800	1169292	 11d78c	net/ipv4/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks a lot Joe.
