Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2FVMYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:24:12 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:44999 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932755Ab2FVMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:24:09 -0400
Date: Fri, 22 Jun 2012 20:24:05 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: crypto: gpf on boot with linux-next
Message-ID: <20120622122405.GA24616@gondor.apana.org.au>
References: <1340363755.27031.37.camel@lappy>
 <20120622120755.GA24338@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622120755.GA24338@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 08:07:55PM +0800, Herbert Xu wrote:
> On Fri, Jun 22, 2012 at 01:15:55PM +0200, Sasha Levin wrote:
> > Hi all,
> > 
> > I'm seeing the following panic when booting the latest linux-next kernel:
> 
> Oops, stupid thinko on my part.  Can you see if the following patch
> on top of linux-next fixes the issue?

For the sake of bisectability I've folded this into the original
patch so you could just test the cryptodev tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
