Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1KCF63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:58:29 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:40820 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1KCF61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:58:27 -0400
Date: Thu, 3 Nov 2011 06:58:24 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Luis Henriques <henrix@camandro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
 tree
Message-ID: <20111103055824.GC22141@secunet.com>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
 <20111102200900.GA3454@hades>
 <20111102233936.GA10058@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102233936.GA10058@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Nov 2011 05:58:24.0585 (UTC) FILETIME=[99578390:01CC99ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 10:39:36AM +1100, Herbert Xu wrote:
> On Wed, Nov 02, 2011 at 08:09:13PM +0000, Luis Henriques wrote:
> >
> > I'm not sure if this is related, but I am currently unable to build mainline
> > kernel when disabling CONFIG_NET.  This seems to be due to the patch serie:
> > 
> > http://news.gmane.org/gmane.linux.kernel.cryptoapi/cutoff=6228
> > 
> > For instance, commit 6ad414fe710d4fd3a8c8c6c2ad8fefcfcc207968 adds a dependency
> > over function nla_put(), which is only defined when CONFIG_NET is enabled.
> 
> Indeed, I missed the dependency in the report functions which
> is built even when CRYPTO_USER is turned off.
> 
> Does this patch fix the problem for you?
> 

Hm, did you forget to add the patch to the mail?
