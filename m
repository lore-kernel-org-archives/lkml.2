Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1ADEhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 23:37:37 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38259 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1ADEhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 23:37:36 -0500
Date: Tue, 4 Jan 2011 15:37:28 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: roel kluin <roel.kluin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: dont return PTR_ERR() of wrong pointer
Message-ID: <20110104043728.GB27632@gondor.apana.org.au>
References: <4D1DF505.3040005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1DF505.3040005@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 04:21:41PM +0100, roel kluin wrote:
> Fix a PTR_ERR() return of the wrong pointer
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
