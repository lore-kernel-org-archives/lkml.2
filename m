Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1EaFW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:22:59 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46973 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab1EaFWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:22:55 -0400
Date: Tue, 31 May 2011 15:22:45 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] crypto: sha1: modify sha1_update to use
	SHA1_BLOCK_SIZE
Message-ID: <20110531052245.GA17068@gondor.apana.org.au>
References: <1306379477-24552-1-git-send-email-msb@chromium.org> <20110525.233411.1372538972166578285.davem@davemloft.net> <20110526232058.GQ11023@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526232058.GQ11023@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 04:20:58PM -0700, Mandeep Singh Baines wrote:
> David Miller (davem@davemloft.net) wrote:
> > 
> > The temp[] buffer is explicitly places inside the inner most
> > basic block so that the compiler doesn't allocate the stack
> > space unless that code path is taken.
> > 
> 
> Fixed in V2 (this patch). Thanks for the review.
> 
> -- >8 -- (snip)
> 
> Plus some other minor cleanup.

I don't really like the cleanups.  In any case, mixing up the
use of SHA1_BLOCK_SIZE with cleanups increases the chance of
introducing a bug.

So please redo the patch with only the addition of SHA1_BLOCK_SIZE
and nothing else.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
