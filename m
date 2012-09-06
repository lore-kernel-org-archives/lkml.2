Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab2IFUUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:20:30 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:55333 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759810Ab2IFUU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:20:28 -0400
Date: Thu, 6 Sep 2012 13:20:25 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David McCullough <david_mccullough@mcafee.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines
Message-ID: <20120906202024.GB24269@gondor.apana.org.au>
References: <20120807020103.GA21410@mcafee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807020103.GA21410@mcafee.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:01:03AM +0000, David McCullough wrote:
> 
> Add assembler versions of AES and SHA1 for ARM platforms.  This has provided
> up to a 50% improvement in IPsec/TCP throughout for tunnels using AES128/SHA1.
> 
> Platform   CPU SPeed    Endian   Before (bps)   After (bps)   Improvement 
> 
> IXP425      533 MHz      big     11217042        15566294        ~38%
> KS8695      166 MHz     little    3828549         5795373        ~51%
> 
> Signed-off-by: David McCullough <ucdevel@gmail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
