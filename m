Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0CXONg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:13:36 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:32859 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752486Ab0CXONe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:13:34 -0400
X-Greylist: delayed 2250 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2010 10:13:34 EDT
Date: Wed, 24 Mar 2010 21:35:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Dan Carpenter <error27@gmail.com>, "David S. Miller" <davem@davemloft.net>,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch v3] pcrypt: handle crypto_get_attr_type() errors
Message-ID: <20100324133550.GA9640@gondor.apana.org.au>
References: <20100321092847.GJ5331@bicker> <20100322132342.GJ20508@secunet.com> <20100322135319.GQ21571@bicker> <20100322145357.GK20508@secunet.com> <20100322152845.GT21571@bicker> <20100323103431.GA27822@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323103431.GA27822@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 11:34:31AM +0100, Steffen Klassert wrote:
> On Mon, Mar 22, 2010 at 06:28:45PM +0300, Dan Carpenter wrote:
> > I was concerned about the error handling for crypto_get_attr_type() in
> > pcrypt_alloc_aead().  Steffen Klassert pointed out that we could simply
> > avoid calling crypto_get_attr_type() if we passed the type and mask as a
> > parameters.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
