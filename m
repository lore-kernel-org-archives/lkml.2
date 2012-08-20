Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2HTIVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:21:30 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:46031 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753905Ab2HTIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:21:25 -0400
Date: Mon, 20 Aug 2012 16:21:03 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 35/74] lto, crypto, aes: mark AES tables __visible
Message-ID: <20120820082103.GA22529@gondor.apana.org.au>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-36-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345345030-22211-36-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 07:56:31PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Various tables in aes_generic are accessed by assembler code.
> Mark them __visible for LTO
> 
> Cc: herbert@gondor.apana.org.au
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
