Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0ITIH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:07:57 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:44076 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab0ITIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:07:55 -0400
Date: Mon, 20 Sep 2010 16:07:52 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Hoban, Adrian" <adrian.hoban@intel.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Message-ID: <20100920080752.GA972@gondor.apana.org.au>
References: <CFBC532374C38D45810FA00BC2D2C2040120CA815D@irsmsx502.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CFBC532374C38D45810FA00BC2D2C2040120CA815D@irsmsx502.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 06:36:24PM +0100, Hoban, Adrian wrote:
> This patch adds an optimized RFC4106 AES-GCM implementation for 64-bit
> kernels. It supports 128-bit AES key size. This leverages the crypto
> AEAD interface type to facilitate a combined AES & GCM operation to
> be implemented in assembly code. The assembly code leverages Intel(R)
> AES New Instructions and the PCLMULQDQ instruction.
> 
> Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
> Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
> Signed-off-by: Erdinc Ozturk <erdinc.ozturk@intel.com>
> Signed-off-by: James Guilford <james.guilford@intel.com>
> Signed-off-by: Edward Clinton <edward.clinton@intel.com>
> Signed-off-by: Wajdi Feghali <wajdi.k.feghali@intel.com>

I've applied patch 1/3 but 2/3 does not apply because you've
converted the tabs to spaces.

Please resend patches 2/3 and 3/3 with a cc to yourself and
double-check that you can still apply the received version.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
