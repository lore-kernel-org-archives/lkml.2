Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0DNDON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:14:13 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:40933 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754618Ab0DNDOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:14:12 -0400
Date: Wed, 14 Apr 2010 11:14:08 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Uri Simchoni <uri@jdland.co.il>
Subject: Re: linux-next: manual merge of the crypto tree with Linus' tree
Message-ID: <20100414031408.GA19203@gondor.apana.org.au>
References: <20100414114856.54e1cb21.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414114856.54e1cb21.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 11:48:56AM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> Today's linux-next merge of the crypto tree got a conflict in
> drivers/crypto/mv_cesa.c between commit
> 5a0e3ad6af8660be21ca98a971cd00f331318c05 ("include cleanup: Update gfp.h
> and slab.h includes to prepare for breaking implicit slab.h inclusion
> from percpu.h") from Linus' tree and commit
> 750052dd2400cd09e0864d75b63c2c0bf605056f ("crypto: mv_cesa - Add sha1 and
> hmac(sha1) async hash drivers") from the crypto tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

Thanks for the heads up Stephen, I will do a merge soon.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
