Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0IGOYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:24:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab0IGOY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:24:28 -0400
Date: Tue, 7 Sep 2010 10:24:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC: Crypto API User-interface
Message-ID: <20100907142427.GA14207@infradead.org>
References: <20100907084213.GA4610@gondor.apana.org.au>
 <20100907140646.GA31921@infradead.org>
 <20100907141112.GB6903@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907141112.GB6903@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 10:11:12PM +0800, Herbert Xu wrote:
> FWIW I don't care about user-space using kernel software crypto at
> all.  It's the security people that do.

And since when did we care about their crack pipe dreams?

> The purpose of the user-space API is to export the hardware crypto
> devices to user-space.  This means PCI devices mostly, as things
> like aesni-intel can already be used without kernel help.

I don't think they matter in practice.  We have less than a handfull
of drivers for them, and with CPUs gaining proper instructions they
are even less useful.  In addition any sane PCI card should just
allow userspace mapping of their descriptors.

> Now as a side-effect if this means that we can shut the security
> people up about adding another interface then all the better.  But
> I will certainly not go out of the way to add more crap to the
> kernel for that purpose.

So what is the real use case for this?  In addition to kernel bloat
the real fear I have is that the security wankers will just configure
the userspace crypto libraries to always use the kernel interface
just in case, and once that happens we will have to deal with the whole
mess.  Especially for RHEL and Fedora where the inmantes now run the
asylum in that respect.

