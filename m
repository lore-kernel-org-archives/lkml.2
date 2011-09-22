Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1IVLdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:33:31 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:47657 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1IVLd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:33:29 -0400
Date: Thu, 22 Sep 2011 21:33:19 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: msb@google.com
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] lib/sha1.c: quite sparse noise about symbol not
	declared
Message-ID: <20110922113318.GA1205@gondor.apana.org.au>
References: <201109091130.28110.hartleys@visionengravers.com> <20110913215851.GD9560@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913215851.GD9560@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 02:58:51PM -0700, msb@google.com wrote:
> +cc linux-crypto, herbert, davem, torvalds
> 
> H Hartley Sweeten (hartleys@visionengravers.com) wrote:
> > Include <linux/cryptohash.h> to pickup the declarations for sha_transform
> > and sha_init to quite the sparse noise:
> > 
> > warning: symbol 'sha_transform' was not declared. Should it be static?
> > warning: symbol 'sha_init' was not declared. Should it be static?
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Mandeep Singh Baines <msb@chromium.org>
> > 
> 
> Acked-by: Mandeep Singh Baines <msb@chromium.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
