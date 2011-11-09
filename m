Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1KIEGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 23:06:05 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:58349 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1KIEGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 23:06:02 -0500
Date: Wed, 9 Nov 2011 12:05:54 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Valdis.Kletnieks@vt.edu
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH][RESEND] fix typo in crypto/Kconfig
Message-ID: <20111109040554.GA19702@gondor.apana.org.au>
References: <21323.1320648711@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21323.1320648711@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:51:51AM -0500, Valdis.Kletnieks@vt.edu wrote:
> (Sent this a while back, I don't see it in next-20111104, so resending)
> 
> Fix a typo in the Kconfig file help text.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Your patch still does not apply:

$ git apply ~/p
error: patch failed: crypto/Kconfig:104
error: crypto/Kconfig: patch does not apply
$ 

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
