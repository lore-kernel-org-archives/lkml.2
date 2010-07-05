Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0GENoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:44:09 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:49621 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0GENoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:44:05 -0400
Date: Mon, 5 Jul 2010 21:43:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fixed division by zero bug in kernel/padata.c
Message-ID: <20100705134357.GC6974@gondor.apana.org.au>
References: <AANLkTimVTMsVkSBHWLve8t76-YkoSYposgv9wHir_wPa@mail.gmail.com> <20100702125628.GK10072@secunet.com> <AANLkTimH9IKkqqLADjUbycKD8bh4oX8oCxSDTCGxv4r1@mail.gmail.com> <20100705131835.GN10072@secunet.com> <AANLkTimvyUiQqAO_uBxTMTLRWdujDWKSo7WBuI7cPLKc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimvyUiQqAO_uBxTMTLRWdujDWKSo7WBuI7cPLKc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 05:35:32PM +0400, Dan Kruchinin wrote:
>
> > Both cases should be handled in the same way. So we could just
> > stop the instance if the cpumasks do not intersect, and enable
> > it as soon as they do intersect again. The padata instance would
> > refuse to do anything as long as the cpumasks do not intersect,
> > but it is still in a consistent state. Let me add the infrastructure
> > to handle this, then you can use it with your patches.
> 
> Ok, get it.

So I should wait for another patch, right?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
