Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190Ab0FWE4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 00:56:18 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:55658 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0FWE4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 00:56:17 -0400
X-Greylist: delayed 2496 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 00:56:16 EDT
Date: Wed, 23 Jun 2010 14:14:33 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: linux-next: manual merge of the net tree with the net-current
	tree
Message-ID: <20100623041433.GB30067@gondor.apana.org.au>
References: <20100623125116.1370bdd4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623125116.1370bdd4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:51:16PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> net/ipv4/ip_output.c between commit
> 26cde9f7e2747b6d254b704594eed87ab959afa5 ("udp: Fix bogus UFO packet
> generation") from the net-current tree and commit
> d8d1f30b95a635dbd610dcc5eb641aca8f4768cf ("net-next: remove useless union
> keyword") from the net tree.
> 
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

Looks good to me.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
