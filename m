Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1K3ITJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:19:09 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51633 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1K3ITC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:19:02 -0500
Date: Wed, 30 Nov 2011 16:18:48 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Clouter <alex@digriz.org.uk>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamie Iles <jamie@jamieiles.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] char: hw_random: convert drivers/char/hw_random/* to
	use module_platform_driver()
Message-ID: <20111130081848.GC692@gondor.apana.org.au>
References: <1322313066.6001.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322313066.6001.3.camel@phoenix>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 09:11:06PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/char/hw_random/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Alexander Clouter <alex@digriz.org.uk>
> Cc: David Daney <ddaney@caviumnetworks.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Olof Johansson <olof@lixom.net>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
