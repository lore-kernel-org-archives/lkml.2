Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1IAGnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:43:31 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:33585 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1IAGn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:43:29 -0400
Date: Thu, 1 Sep 2011 14:43:19 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Message-ID: <20110901064319.GB27893@gondor.apana.org.au>
References: <20110901021534.GA26330@gondor.apana.org.au> <4E5F257F.9060202@gnutls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5F257F.9060202@gnutls.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 08:26:07AM +0200, Nikos Mavrogiannopoulos wrote:
>
> Actually this is the reason of the ecb(cipher-null) comparison. To  
> emulate the case of a hardware offload device. I tried to make that  
> clear in the text, but may not be. If you see AF_ALG performs really bad  
> on that case. It performs better when a software or a padlock  
> implementation of AES is involved (which as you say it is a useless  
> use-case).

It's meaningless because such devices operate at a rate much
lower than the figures you give.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
