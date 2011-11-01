Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750884Ab1KAFSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 01:18:15 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39884 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1KAFSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 01:18:13 -0400
Date: Tue, 1 Nov 2011 16:18:10 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
	tree
Message-ID: <20111101051810.GA7519@gondor.apana.org.au>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au> <20111101152312.5751b7ac8b4a998b6ef867be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101152312.5751b7ac8b4a998b6ef867be@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 03:23:12PM +1100, Stephen Rothwell wrote:
> Hi Herbert,
> 
> On Tue, 1 Nov 2011 11:58:51 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Presumbly caused by commit ea8bdfcff175 ("crypto: user - Add dependency
> > on NET").
> > 
> > I have used the crypto-current tree from next-20111025 for today (i.e. that
> > commit has not been added to linux-next today).
> 
> Same problem and solution in the crypto tree (obviously).

So did the change to depends_on fix it?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
