Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0FWKCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:02:15 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:54353 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0FWKCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:02:05 -0400
Date: Wed, 23 Jun 2010 20:01:55 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH] CRYPTO: ablkcipher, avoid NULL dereference
Message-ID: <20100623100155.GA32739@gondor.apana.org.au>
References: <1277132483-14172-1-git-send-email-jslaby@suse.cz> <20100621.134452.39190078.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621.134452.39190078.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 01:44:52PM -0700, David Miller wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> Date: Mon, 21 Jun 2010 17:01:23 +0200
> 
> > Stanse found a potential NULL dereference in ablkcipher_next_slow.
> > Even though kmalloc fails, its retval is dereferenced later. Return
> > from that function properly earlier.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Thanks for fixing this:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Patch applied to crypt-2.6.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
