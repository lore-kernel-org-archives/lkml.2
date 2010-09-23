Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0IWH6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 03:58:44 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36586 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0IWH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 03:58:43 -0400
Date: Thu, 23 Sep 2010 15:58:40 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Struk, Tadeusz" <tadeusz.struk@intel.com>
Cc: "Hoban, Adrian" <adrian.hoban@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Message-ID: <20100923075840.GA30301@gondor.apana.org.au>
References: <CFBC532374C38D45810FA00BC2D2C2040120CA815D@irsmsx502.ger.corp.intel.com> <20100920080752.GA972@gondor.apana.org.au> <AANLkTim_gVO2tHUw+vFC9vXRh8Dtv7N38HTCMUZ7LmNg@mail.gmail.com> <24483BA4C9F69C43A7379639D35543D7B6E12F4C@irsmsx502.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24483BA4C9F69C43A7379639D35543D7B6E12F4C@irsmsx502.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 12:21:54PM +0100, Struk, Tadeusz wrote:
> Hello Herbert,
> I've reworked the patch 2/3 and successfully applied all of them.
> The problem was spaces at EOL.
> Please find the reworked patch below.
> 
> >From 06444d8a95458d807ae14699e557739281d0b026 Mon Sep 17 00:00:00 2001
> From: Adrian Hoban <ahoban@allen.ir.intel.com>
> Date: Fri, 10 Sep 2010 18:08:45 +0100
> Subject: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
> 
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
> Signed-off-by: Wajdi Feghali <wajdi.k.feghali@intel.com>

Sorry, still doesn't work:

$ git apply ~/p
fatal: corrupt patch at line 67
$ patch -s -p1 < ~/p
patch: **** malformed patch at line 66: ALL_F
$

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
