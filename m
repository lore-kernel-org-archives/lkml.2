Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1EDFN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 01:13:58 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39150 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1EDFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 01:13:57 -0400
Date: Wed, 4 May 2011 15:13:51 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwrng: manage resource allocation in amd driver
Message-ID: <20110504051351.GA7040@gondor.apana.org.au>
References: <1303932076-7428-1-git-send-email-dbaryshkov@gmail.com> <1304020313.20288.1.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304020313.20288.1.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 02:51:53PM -0500, Matt Mackall wrote:
> On Wed, 2011-04-27 at 23:21 +0400, Dmitry Eremin-Solenikov wrote:
> > As amd driver doesn't bind to PCI device, we'd better manage reource
> > allocation on our own to disallow (possible) conflicts.
> 
> These two look good to me.
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

All applied.  Thanks a lot.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
