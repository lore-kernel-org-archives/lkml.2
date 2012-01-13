Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab2AMFgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 00:36:43 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:60826 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2AMFgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 00:36:42 -0500
Date: Fri, 13 Jan 2012 16:36:33 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Julia Lawall <julia@diku.dk>
Cc: Matt Mackall <mpm@selenic.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] drivers/char/hw_random/tx4939-rng.c: use
	devm_request_and_ioremap
Message-ID: <20120113053633.GD13918@gondor.apana.org.au>
References: <1324994491-21828-1-git-send-email-julia@diku.dk> <1324994491-21828-6-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324994491-21828-6-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 03:01:30PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Reimplement a call to devm_request_mem_region followed by a call to ioremap
> or ioremap_nocache by a call to devm_request_and_ioremap.

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
