Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab2CHAic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:38:32 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:40602 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703Ab2CHAia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:38:30 -0500
Date: Thu, 8 Mar 2012 11:37:42 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Wouters <pwouters@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Willi <martin@strongswan.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] xfrm: fix hmac(sha256) truncation length
Message-ID: <20120308003741.GA14995@gondor.apana.org.au>
References: <1331151157-19149-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331151157-19149-1-git-send-email-jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 03:12:37PM -0500, Jarod Wilson wrote:
> Commit bc74b0c8af17458ecae77f725e507ab5fd100105 added proper hmac sha384
> and sha512 variants with truncation lengths of 192 and 256 respectively,
> per RFC4868:

No, it was done deliberately to maintain backwards compatibility.
Userspace should set the truncbits explicitly from now on.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
