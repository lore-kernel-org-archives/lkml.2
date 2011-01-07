Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1AGDEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:04:46 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59598 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1AGDEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:04:44 -0500
Date: Fri, 7 Jan 2011 14:04:39 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110107030439.GA884@gondor.apana.org.au>
References: <20110106225301.GA27358@gondor.apana.org.au> <AANLkTi=E3fqTos7A2fJ2PRKT=o5=sgWh+CzMv4G7P4rZ@mail.gmail.com> <20110107001459.GA32068@gondor.apana.org.au> <20110106.184302.193709839.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106.184302.193709839.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 06:43:02PM -0800, David Miller wrote:
>
> davem@maramba:~$ time ./crypto_user_test >/dev/null
> 
> real		 0m46.586s
> user		 0m3.280s
> sys		 0m43.230s
> davem@maramba:~$ time ./crypto_user_test software >/dev/null
> 
> real		 10m40.336s
> user		 10m40.540s
> sys		 0m0.000s
> davem@maramba:~$   
> 
> What's that, something like a factor of 13 faster? :-)

Heh, I missed the leading 1 in your second result and was about
to spill my drink :)

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
