Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1KJWuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:50:40 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55892 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1KJWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:50:38 -0500
Date: Fri, 11 Nov 2011 06:50:20 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Luis Henriques <henrix@camandro.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
	tree
Message-ID: <20111110225020.GB4318@gondor.apana.org.au>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au> <20111102200900.GA3454@hades> <20111102233936.GA10058@gondor.apana.org.au> <20111103055824.GC22141@secunet.com> <20111103061628.GA12678@gondor.apana.org.au> <20111103101554.GA17569@onza.mythic-beasts.com> <20111103114214.GA14681@gondor.apana.org.au> <20111103115933.GA12708@onza.mythic-beasts.com> <20111110155019.GA7068@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110155019.GA7068@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 04:50:19PM +0100, Ingo Molnar wrote:
>
> v3.2-rc1 has been released with this (commonly triggering) build bug 
> included. Herbert, is the fix on the way to upstream?

Oops, I thought I had committed it already.  Let me push it now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
