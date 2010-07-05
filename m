Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0GENWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:22:51 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:33552 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0GENWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:22:50 -0400
Date: Mon, 5 Jul 2010 21:22:45 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Fwd: Possible bug in net/ipv4/route.c?
Message-ID: <20100705132245.GA6876@gondor.apana.org.au>
References: <20100705120617.GA6267@gondor.apana.org.au> <1278334754.2877.173.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278334754.2877.173.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 02:59:14PM +0200, Eric Dumazet wrote:
>
> Why do we clear full 48 bytes skb->cb[] in skb_alloc(), if no protocol
> stack should rely it being zero ?

Unless a protocol is allocating the skb itself, then the fact
that skb_alloc clears skb->cb is no guarantee that the skb->cb
will be zero.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
