Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0GaL6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 07:58:34 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:42856 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0GaL6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 07:58:32 -0400
Date: Sat, 31 Jul 2010 19:58:19 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: reorder struct entropy_store to remove padding
	on 64bits
Message-ID: <20100731115819.GA18319@gondor.apana.org.au>
References: <1280309521.2029.5.camel@castor.rsk> <1280332948.11415.705.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280332948.11415.705.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 11:02:28AM -0500, Matt Mackall wrote:
> On Wed, 2010-07-28 at 10:32 +0100, Richard Kennedy wrote:
> > Re-order structure entropy_store to remove 8 bytes of padding on
> > 64 bit builds, so shrinking this structure from 72 to 64 bytes
> > and allowing it to fit into one cache line.
> 
> I have a vague memory that we reordered things so that the r/w bits
> would be on a separate cache line than the r/o bits. But as we never
> added the alignment primitives to actually enforce that, I guess it
> doesn't matter much. 
> 
> > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
