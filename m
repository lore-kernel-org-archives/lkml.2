Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab1BPCEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:04:46 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:47728 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab1BPCEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:04:32 -0500
Date: Wed, 16 Feb 2011 13:04:21 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Paoloni, Gabriele" <gabriele.paoloni@intel.com>, tadeusz.struk@intel.com,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Subject: Re: [PATCH](updated) rfc4106, Intel, AES-NI: Don't leak memory in
	rfc4106_set_hash_subkey()..
Message-ID: <20110216020421.GA8201@gondor.apana.org.au>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com> <alpine.LNX.2.00.1102071922220.27796@swampdragon.chaosbits.net> <20110211142647.GA3920@ucw.cz> <DF7BB929B28FCF479E888E3D9F8D9E88F3E2E668@irsmsx502.ger.corp.intel.com> <alpine.LNX.2.00.1102111546310.13370@swampdragon.chaosbits.net> <alpine.LNX.2.00.1102112204020.16994@swampdragon.chaosbits.net> <alpine.LNX.2.00.1102112211230.16994@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1102112211230.16994@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:14:44PM +0100, Jesper Juhl wrote:
> 
> And of course I just had to screw up and send the wrong diff. The one I 
> sent does not compile and was a temporary file I imported into the mail by 
> accident :-(
> Below is the real patch - changelog above still applies - sorry about 
> that.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
