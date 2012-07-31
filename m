Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2GaWQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:16:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:56658 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab2GaWQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:16:17 -0400
Message-ID: <1343772951.16975.18.camel@pasglop>
Subject: Re: CRYPTO_DEV_NX merge problem (Re: linux-next: Tree for July 31)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>, anton@samba.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Wed, 01 Aug 2012 08:15:51 +1000
In-Reply-To: <19970.1343772018@neuling.org>
References: <20120731152614.de6ebe9e0d4b8fc6645b793a@canb.auug.org.au>
	 <31974.1343714338@neuling.org> <5017DE06.3000103@linux.vnet.ibm.com>
	 <19970.1343772018@neuling.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 08:00 +1000, Michael Neuling wrote:
> 
> OK.  Please post the fix as a patch.  Anton's patch is already in the
> powerpc next tree so it won't be changed/rebased directly.  
> 
> I'm not sure who can carry this, since the crypto tree doesn't have
> Anton's change and the powerpc tree doesn't have Seth's change.
> 
> sfr: who normally carries it when we have a merge issue like this?
> You?

There is no powerpc -next tree at this point, Anton patch is either
upstream or in no tree.

Cheers,
Ben.


