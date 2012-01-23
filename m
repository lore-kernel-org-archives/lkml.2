Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2AWCDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:03:22 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39320 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2AWCDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:03:20 -0500
Date: Mon, 23 Jan 2012 13:03:12 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henning Heinold <heinold@inf.fu-berlin.de>,
        Varun Wadekar <vwadekar@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>
Subject: Re: linux-next: manual merge of the crypto tree with the tegra tree
Message-ID: <20120123020312.GA31912@gondor.apana.org.au>
References: <20120123120933.6d4c9cc7050fce2e9fbc9d3a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123120933.6d4c9cc7050fce2e9fbc9d3a@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:09:33PM +1100, Stephen Rothwell wrote:
> Hi Herbert,
> 
> Today's linux-next merge of the crypto tree got a conflict in
> arch/arm/mach-tegra/fuse.c between commit b2609c7c7237 ("ARM: tegra:
> fuse: add functions to access chip revision") from the tegra tree and
> commit e87e06cd8cc0 ("arm: tegra: export tegra_chip_uid") from the crypto
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks!

> By the way, adding the EXPORT_SYMBOL() really now only needs export.h not
> module.h (assuming that the crypto tree has a recent enough base).

OK noted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
