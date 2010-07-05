Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0GENvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:51:16 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:48075 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0GENvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:51:15 -0400
Date: Mon, 5 Jul 2010 15:53:06 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fixed division by zero bug in kernel/padata.c
Message-ID: <20100705135306.GP10072@secunet.com>
References: <AANLkTimVTMsVkSBHWLve8t76-YkoSYposgv9wHir_wPa@mail.gmail.com>
 <20100702125628.GK10072@secunet.com>
 <AANLkTimH9IKkqqLADjUbycKD8bh4oX8oCxSDTCGxv4r1@mail.gmail.com>
 <20100705131835.GN10072@secunet.com>
 <AANLkTimvyUiQqAO_uBxTMTLRWdujDWKSo7WBuI7cPLKc@mail.gmail.com>
 <20100705134357.GC6974@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705134357.GC6974@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Jul 2010 13:51:13.0486 (UTC) FILETIME=[21C3C6E0:01CB1C49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 09:43:57PM +0800, Herbert Xu wrote:
> On Mon, Jul 05, 2010 at 05:35:32PM +0400, Dan Kruchinin wrote:
> >
> > > Both cases should be handled in the same way. So we could just
> > > stop the instance if the cpumasks do not intersect, and enable
> > > it as soon as they do intersect again. The padata instance would
> > > refuse to do anything as long as the cpumasks do not intersect,
> > > but it is still in a consistent state. Let me add the infrastructure
> > > to handle this, then you can use it with your patches.
> > 
> > Ok, get it.
> 
> So I should wait for another patch, right?
> 

Right.
