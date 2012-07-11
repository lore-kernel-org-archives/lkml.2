Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2GKD0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:26:23 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:49796 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754585Ab2GKD0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:26:22 -0400
Date: Wed, 11 Jul 2012 11:26:19 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: twofish-avx - remove useless instruction
Message-ID: <20120711032618.GH5263@gondor.apana.org.au>
References: <20120705184358.GE2091@kronos.redsun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705184358.GE2091@kronos.redsun>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:43:58PM +0200, Johannes Goetzfried wrote:
> The register %rdx is written, but never read till the end of the encryption
> routine. Therefore let's delete the useless instruction.
> 
> Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
