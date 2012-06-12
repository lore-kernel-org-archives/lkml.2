Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2FLKGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:06:08 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:48653 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750985Ab2FLKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:06:05 -0400
Date: Tue, 12 Jun 2012 18:05:51 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: s390 - clean up DES code a bit more
Message-ID: <20120612100551.GF14078@gondor.apana.org.au>
References: <1339194367.30984.18.camel@x61.thuisdomein>
 <1339403679.9116.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339403679.9116.0.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:34:39AM +0200, Jan Glauber wrote:
> On Sat, 2012-06-09 at 00:26 +0200, Paul Bolle wrote:
> > Commit 98971f8439b1bb9a61682fe24a865ddd25167a6b ("crypto: s390 - cleanup
> > DES code") should have also removed crypto_des.h. That file is unused
> > and unneeded since that commit. So let's clean up that file too.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested. Ought to be correct.
> > 
> >  arch/s390/crypto/crypto_des.h |   18 ------------------
> >  1 files changed, 0 insertions(+), 18 deletions(-)
> >  delete mode 100644 arch/s390/crypto/crypto_des.h
> 
> Looks good!
> 
> Acked-by: Jan Glauber <jang@linux.vnet.ibm.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
