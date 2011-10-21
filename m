Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1JUMjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:39:44 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:56721 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JUMjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:39:43 -0400
Date: Fri, 21 Oct 2011 14:39:39 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] crypto: Make hifn_795x build depend on
	!ARCH_DMA_ADDR_T_64BIT
Message-ID: <20111021123939.GG17486@gondor.apana.org.au>
References: <1318244141-10879-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318244141-10879-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 12:55:41PM +0200, Richard Weinberger wrote:
> hifn_795x works only on 32 bit, remove the detection while loading
> the module and catch non-32 bit systems at build time.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
