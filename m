Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1CVJED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:04:03 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:48290 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1CVJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:04:00 -0400
Date: Tue, 22 Mar 2011 17:03:50 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: George Spelvin <linux@horizon.com>
Cc: hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mpm@selenic.com, penberg@cs.helsinki.fi
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
Message-ID: <20110322090350.GA23736@gondor.apana.org.au>
References: <alpine.LSU.2.00.1103161123360.14076@sister.anvils> <20110316194542.22530.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316194542.22530.qmail@science.horizon.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 03:45:42PM -0400, George Spelvin wrote:
>
> > Ah, now you come clean!  Yes, it does feel neater to me too;
> > but I doubt that would be sufficient justification by itself.
> 
> It took both factors to make it worth it to me.  The real reason was:
> 1) Neater
> 2) Definitely not slower
> 3) Maybe a tiny bit faster
> Conclusion: do it.

I'm with Hugh on this, the justification seems pretty weak.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
