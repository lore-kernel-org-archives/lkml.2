Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2CMAGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:06:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53027 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2CMAGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:06:02 -0400
Date: Mon, 12 Mar 2012 17:05:58 -0700 (PDT)
Message-Id: <20120312.170558.584205292599435892.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipv4: Standardize prefixes for message
 logging
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331571812.13200.23.camel@joe2Laptop>
References: <1331526971.13200.9.camel@joe2Laptop>
	<20120311.234846.455580505379366792.davem@davemloft.net>
	<1331571812.13200.23.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 17:05:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 12 Mar 2012 10:03:32 -0700

> Add #define pr_fmt(fmt) as appropriate.
> 
> Add "IPv4: ", "TCP: ", and "IPsec: " to appropriate files.
> Standardize on "UDPLite: " for appropriate uses.
> Some prefixes were previously "UDPLITE: " and "UDP-Lite: ".
> 
> Add KBUILD_MODNAME ": " to icmp and gre.
> Remove embedded prefixes as appropriate.
> 
> Add missing "\n" to pr_info in gre.c.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good, and applied, but I left out this hunk:

> diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
> index 63b64c4..56d6768 100644
> --- a/net/ipv4/ipcomp.c
> +++ b/net/ipv4/ipcomp.c
> @@ -13,6 +13,7 @@
>   *   - Compression stats.
>   *   - Adaptive compression.
>   */
> +
>  #include <linux/module.h>
>  #include <linux/err.h>
>  #include <linux/rtnetlink.h>

As it seemed accidental, if not gratuitous.
