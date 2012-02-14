Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab2BNIfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:35:11 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59759 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2BNIfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:35:09 -0500
Date: Tue, 14 Feb 2012 19:34:59 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jesper Juhl <jj@chaosbits.net>
Cc: x86@kernel.org, trivial@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] X86, crypto: Remove dead code from
	twofish_glue_3way.c::init()
Message-ID: <20120214083458.GB28942@gondor.apana.org.au>
References: <alpine.LNX.2.00.1202092300300.32491@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202092300300.32491@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 11:02:16PM +0100, Jesper Juhl wrote:
> We can never reach the line just after the 'return 0'
> statement. Remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
