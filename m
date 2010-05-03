Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0ECDiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 23:38:17 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:43026 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752403Ab0ECDiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 23:38:13 -0400
Date: Mon, 3 May 2010 11:38:04 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] padata: Use a timer to handle the reorder queues
Message-ID: <20100503033804.GA31605@gondor.apana.org.au>
References: <20100429123636.GD5275@secunet.com> <20100429124337.GJ5275@secunet.com> <20100429160644.4dee414d.akpm@linux-foundation.org> <20100430112000.GM5275@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430112000.GM5275@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 01:20:00PM +0200, Steffen Klassert wrote:
> On Thu, Apr 29, 2010 at 04:06:44PM -0700, Andrew Morton wrote:
> > On Thu, 29 Apr 2010 14:43:37 +0200
> > Steffen Klassert <steffen.klassert@secunet.com> wrote:
> > 
> > > padata_get_next had a bogus check that returned always true,
> > > so the try_again loop in padata_reorder was never taken.
> > 
> > A better changelog would have told us what this "bogus check" _is_.
> > 
> > > This can lead to object leaks in some rare cases.
> > 
> > And a better changelog would describe those leaks!
> 
> I'll try to write a better one and resent.

I've picked up patches 1-5.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
