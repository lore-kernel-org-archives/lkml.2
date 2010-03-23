Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0CWKc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:32:28 -0400
Received: from a.mx.secunet.com ([213.68.205.161]:52458 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0CWKc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:32:26 -0400
Date: Tue, 23 Mar 2010 11:34:31 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Carpenter <error27@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v3] pcrypt: handle crypto_get_attr_type() errors
Message-ID: <20100323103431.GA27822@secunet.com>
References: <20100321092847.GJ5331@bicker>
 <20100322132342.GJ20508@secunet.com>
 <20100322135319.GQ21571@bicker>
 <20100322145357.GK20508@secunet.com>
 <20100322152845.GT21571@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322152845.GT21571@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Mar 2010 10:32:24.0387 (UTC) FILETIME=[2081B930:01CACA74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 06:28:45PM +0300, Dan Carpenter wrote:
> I was concerned about the error handling for crypto_get_attr_type() in
> pcrypt_alloc_aead().  Steffen Klassert pointed out that we could simply
> avoid calling crypto_get_attr_type() if we passed the type and mask as a
> parameters.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks a lot!

> ---
> All three versions have basically been the same except for style issues.
> I will confess that this (hopefully final :P) version looks much nicer 
> than the earlier ones.
> 

It's not only style issues. We also got some additional benefit from
this version. We got rid of a superfluous call to crypto_get_attr_type
and we are able to change type and mask before we pass it to
pcrypt_alloc_aead if this becomes necessary.

Steffen
