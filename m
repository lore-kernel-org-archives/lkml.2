Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1EZDaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:30:12 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45240 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab1EZDaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:30:11 -0400
Date: Thu, 26 May 2011 13:29:45 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/8] x86: Fix set but not used in ghash_async_setkey()
Message-ID: <20110526032945.GA14500@gondor.apana.org.au>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi> <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 04:12:59PM -0300, Gustavo F. Padovan wrote:
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

Patch applied.  Thanks a lot.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
