Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab2CINpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:45:49 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:34369 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753867Ab2CINps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:45:48 -0500
Date: Sat, 10 Mar 2012 00:45:42 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Wouters <pwouters@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Willi <martin@strongswan.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] xfrm: fix hmac(sha256) truncation length
Message-ID: <20120309134541.GA28309@gondor.apana.org.au>
References: <1331151157-19149-1-git-send-email-jarod@redhat.com> <20120308003741.GA14995@gondor.apana.org.au> <4F5A0876.3060408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5A0876.3060408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 08:41:10AM -0500, Jarod Wilson wrote:
>
> Okay, I suspected that might be the case. No plans to ever invert that,  
> so that userspace has to explicitly set the shorter truncbits for  
> backwards compat?

That's up to the userspace implementation.  If its configuration
allows explicit trunc bits then just use whatever the user says.
Otherwise it'll have to make a policy decision.  For example, a
big warning when upgrading and changing the default to the correct
value.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
