Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0FCKyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:54:01 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:56567 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845Ab0FCKx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:53:59 -0400
Date: Thu, 3 Jun 2010 20:53:56 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: add an option to disable cryptoalgos'
	self-tests
Message-ID: <20100603105356.GC31063@gondor.apana.org.au>
References: <20100526004357.GE20073@gondor.apana.org.au> <1274866114-15817-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274866114-15817-1-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:28:34PM +0300, Alexander Shishkin wrote:
> By default, CONFIG_CRYPTO_MANAGER_TESTS will be enabled and thus
> self-tests will still run, but it is now possible to disable them
> to gain some time during bootup.
> 
> Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: linux-kernel@vger.kernel.org
> CC: linux-crypto@vger.kernel.org

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
