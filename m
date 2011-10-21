Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1JUNZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 09:25:00 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59357 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1JUNY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 09:24:58 -0400
Date: Fri, 21 Oct 2011 15:24:44 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        chris.mason@oracle.com, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, dedekind1@gmail.com, adrian.hunter@intel.com
Subject: Re: [PATCH 3/3] Add snappy interface to crypto API
Message-ID: <20111021132444.GA1141@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319153941-26234-3-git-send-email-andi@firstfloor.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Mainly so that ubifs can use it.
> 
> Snappy is a better compressor in the same niche as LZO.
> 
> Only lightly tested so far. Experiences welcome.
> 
> Cc: herbert@gondor.apana.org.au
> Cc: dedekind1@gmail.com
> Cc: adrian.hunter@intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
