Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1HOHVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:21:01 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:37267 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1HOHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:20:59 -0400
Date: Mon, 15 Aug 2011 15:20:52 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n2_crypto: Fix a get/put_cpu() imbalance
Message-ID: <20110815072052.GA29799@gondor.apana.org.au>
References: <1312619188.5589.27.camel@localhost.localdomain> <20110810105958.GA2607@gondor.apana.org.au> <1313222402.16820.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313222402.16820.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 09:59:58AM +0200, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
> Fix a get/put_cpu() imbalance in the error case when qp == NULL
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
