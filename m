Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0JYX0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:26:10 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:54927 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab0JYX0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:26:08 -0400
Date: Mon, 25 Oct 2010 19:26:04 -0400
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: nikai@nikai.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/crypto: dubious error check
Message-ID: <20101025232604.GA5728@gondor.apana.org.au>
References: <20101024150556.22f49c6a@absol.kitzblitz> <20101024.093949.71101214.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024.093949.71101214.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 09:39:49AM -0700, David Miller wrote:
> From: Nicolas Kaiser <nikai@nikai.net>
> Date: Sun, 24 Oct 2010 15:05:56 +0200
> 
> > Looks like a copy-and-paste problem to me.
> > 
> > Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Applied to crypto-2.6.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
