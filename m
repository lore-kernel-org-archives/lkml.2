Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2BEENq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 23:13:46 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56351 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab2BEENK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 23:13:10 -0500
Date: Sun, 5 Feb 2012 15:12:52 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Jesper Juhl <jj@chaosbits.net>, "devendra.aaru" <devendra.aaru@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized
	to 0
Message-ID: <20120205041251.GA8219@gondor.apana.org.au>
References: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net> <CAHdPZaP4aArSh7G15KhP2ombW8Zs2L4osQ0xi0W829oBZSuTtg@mail.gmail.com> <alpine.LNX.2.00.1202012050390.8577@swampdragon.chaosbits.net> <20120202075122.GA23142@secunet.com> <alpine.LNX.2.00.1202021541440.12088@swampdragon.chaosbits.net> <20120203062425.GH23142@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203062425.GH23142@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 07:24:25AM +0100, Steffen Klassert wrote:
> On Thu, Feb 02, 2012 at 03:42:43PM +0100, Jesper Juhl wrote:
> > On Thu, 2 Feb 2012, Steffen Klassert wrote:
> > > 
> > > Your first patch is correct.
> > > 
> > Thank you for the explanation.
> > 
> > Can I take that to mean that I can add your Acked-by: if/when I resend the 
> > patch?
> > 
> 
> Sure,
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
