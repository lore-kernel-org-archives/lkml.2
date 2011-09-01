Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1IAPN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:13:58 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:49645 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab1IAPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:13:57 -0400
Date: Thu, 1 Sep 2011 23:13:53 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: nmav@gnutls.org, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Message-ID: <20110901151352.GA32055@gondor.apana.org.au>
References: <20110901133952.GB14522@orbit.nwl.cc> <20110901141445.GA31447@gondor.apana.org.au> <20110901150928.GC14522@orbit.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901150928.GC14522@orbit.nwl.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 05:09:28PM +0200, Phil Sutter wrote:
>
> Good point. So in order to also test the throughput, I've put my OpenRD
> under load:

No that's not what I meant.  You're pushing a request to an
async device and waiting for a response to come back before
pushing the next request.  In order to maximise throughput,
you need to issue your requests without waiting for the responses
synchronously.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
