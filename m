Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1CJIoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:44:06 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57610 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1CJIoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:44:03 -0500
Date: Thu, 10 Mar 2011 16:43:46 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for
	crc32c_intel
Message-ID: <20110310084346.GA10650@gondor.apana.org.au>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 12:21:10AM -0800, Nicholas A. Bellinger wrote:
> 
> Nicholas Bellinger (2):
>   crypto: Add struct crypto_alg->cra_check_optimized
>   crypto/crc32c: Add crc32c_cra_check_optimized for crc32c_intel

I think you misunderstood my suggestion.  The reason I asked
for this to be done in the crypto API is because it is not specific
to crc32c_intel.

So sending me a patch that modifies crc32c clearly misses the
point :)

This should be done in the core API, i.e., api.c/algapi.c.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
