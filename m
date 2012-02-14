Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2BNIeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:34:20 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55774 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2BNIeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:34:18 -0500
Date: Tue, 14 Feb 2012 19:34:07 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tristan Pourcelot <tristan.pourcelot@gmail.com>
Cc: davem@davemloft.net, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] Correcting some style issues in
	drivers/crypto/geode-aes.c
Message-ID: <20120214083407.GA28942@gondor.apana.org.au>
References: <1328190031.6508.1.camel@blackout-netbook> <20120205041424.GB8219@gondor.apana.org.au> <1328648765.29061.3.camel@blackout-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1328648765.29061.3.camel@blackout-netbook>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 10:06:05PM +0100, Tristan Pourcelot wrote:
> Le dimanche 05 février 2012 à 15:14 +1100, Herbert Xu a écrit :
> > On Thu, Feb 02, 2012 at 02:40:31PM +0100, Tristan Pourcelot wrote:
> > > >From d50e5530201aa02a5232ca9f2458a7fdd18de374 Mon Sep 17 00:00:00 2001
> > > From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
> > > Date: Thu, 2 Feb 2012 14:01:03 +0100
> > > Subject: [PATCH] Correcting some style errors in
> > >  drivers/crypto/geode-aes.c 
> > > Signed-off-by: Tristan Pourcelot <tristan.pourcelot@gmail.com>
> > 
> > Sorry, your patch doesn't apply against cryptodev:
> Sorry, I messed up my patch.
> Here is a correct version that should apply correctly.

Sigh, it's still broken.  Please try applying the patch the list
sends back to you.  Your mailer is wrapping long lines.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
