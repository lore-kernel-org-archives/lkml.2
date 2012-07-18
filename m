Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2GRAs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:48:27 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:48215 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978Ab2GRAsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:48:23 -0400
Date: Wed, 18 Jul 2012 08:48:19 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/17] n2_crypto: remove IRQF_SAMPLE_RANDOM which is
 now a no-op
Message-ID: <20120718004819.GA27984@gondor.apana.org.au>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
 <1342560756-18737-6-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342560756-18737-6-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 05:32:24PM -0400, Theodore Ts'o wrote:
> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> no-op; interrupt randomness is now collected unconditionally in a very
> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> flag was scheduled to be removed in 2009 on the
> feature-removal-schedule, so this patch is preparation for the final
> removal of this flag.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
