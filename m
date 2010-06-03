Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab0FCKDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:03:30 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:35507 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507Ab0FCKD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:03:28 -0400
Date: Thu, 3 Jun 2010 20:03:09 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: w.sang@pengutronix.de, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       grant.likely@secretlab.ca, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] of/crypto: n2_core: fix build breakage
Message-ID: <20100603100309.GA30618@gondor.apana.org.au>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com> <1275537827-28921-2-git-send-email-w.sang@pengutronix.de> <20100603.024902.139551876.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603.024902.139551876.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:49:02AM -0700, David Miller wrote:
> From: Wolfram Sang <w.sang@pengutronix.de>
> Date: Thu,  3 Jun 2010 06:03:47 +0200
> 
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> 
> Herbert you really need to push your pending crypto tree stuff to
> Linus, this is the second time this build fix has been posted just
> today alone and it's in your tree since last week :-)

Sorry, I hadn't realised that the breakage was in the main tree
as opposed to linux-next.

I'll push it out now.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
