Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1DHMla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 08:41:30 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:40858 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab1DHMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 08:41:28 -0400
Date: Fri, 8 Apr 2011 20:39:39 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Steve Cornelius <sec@pobox.com>, Dan Carpenter <error27@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers/crypto/caam/caamalg.c: introduce missing
	kfree
Message-ID: <20110408123939.GA19398@gondor.apana.org.au>
References: <1301667827-20056-2-git-send-email-julia@diku.dk> <20110401144205.b050c598.kim.phillips@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401144205.b050c598.kim.phillips@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 02:42:05PM -0500, Kim Phillips wrote:
> On Fri, 1 Apr 2011 16:23:43 +0200
> Julia Lawall <julia@diku.dk> wrote:
> 
> > Error handling code following a kmalloc should free the allocated data.
> 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > ---
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
