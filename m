Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2DPMsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:48:52 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:47327 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753493Ab2DPMsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:48:51 -0400
Date: Mon, 16 Apr 2012 20:48:39 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Jan Simonson <jan@simonson.se>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Problem with crypto when initializing TKIP
Message-ID: <20120416124839.GA5985@gondor.apana.org.au>
References: <4F8BAE2F.5090200@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8BAE2F.5090200@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 12:29:19AM -0500, Larry Finger wrote:
>
> The value of ok is NOTIFY_OK, which leads to a return of -ENOENT and
> a failure of the initialization.

NOTIFY_OK means that we have no notifiers installed.  Did you
compile/load CRYPTO_MANAGER?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
