Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2JOOeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:34:25 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:54714 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131Ab2JOOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:34:24 -0400
Date: Mon, 15 Oct 2012 22:34:01 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Salman Qazi <sqazi@google.com>
Cc: Shane Wang <shane.wang@intel.com>, Joseph Cihula <joseph.cihula@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: Make VMAC work when blocks aren't aligned
Message-ID: <20121015143401.GD25426@gondor.apana.org.au>
References: <20121005212414.31689.25033.stgit@dungbeetle.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005212414.31689.25033.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 02:24:14PM -0700, Salman Qazi wrote:
> VMAC implementation, as it is, does not work with blocks that
> are not multiples of 128-bytes.  Furthermore, this is a problem
> when using the implementation on scatterlists, even
> when the complete plain text is 128-byte multiple, as the pieces
> that get passed to vmac_update can be pretty much any size.
> 
> I also added test cases for unaligned blocks.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
