Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1HSHca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:32:30 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:38099 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1HSHc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:32:27 -0400
Date: Fri, 19 Aug 2011 15:32:24 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Message-ID: <20110819073224.GA3658@gondor.apana.org.au>
References: <20110811164040.GB2167@zod.bos.redhat.com> <20110815071528.GA29656@gondor.apana.org.au> <20110815115038.GA2227@zod.bos.redhat.com> <20110816123227.GB9413@gondor.apana.org.au> <20110818174425.GN2227@zod.bos.redhat.com> <20110819000229.GA1076@gondor.apana.org.au> <20110819021516.GU2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819021516.GU2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 10:15:17PM -0400, Josh Boyer wrote:
> On Fri, Aug 19, 2011 at 08:02:29AM +0800, Herbert Xu wrote:
> > On Thu, Aug 18, 2011 at 01:44:25PM -0400, Josh Boyer wrote:
> > >
> > > Any luck on this?  If there's anything further I can try or if you need
> > > some data from me, just let me know.
> > 
> > Can you send me your .config file?
> 
> Sure.  It's simply the default Fedora config for F15, F16, etc.
> 
> F15 is using "2.6.40" which is just a rebranded 3.0.  Attached.

Thanks, this looks like a registration ordering problem between
aesni and cryptd.

Can you try building aesni as a module and see if that fixes the
issue?

Meanwhile I'll make a patch that ensures cryptd is registered
before aesni.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
