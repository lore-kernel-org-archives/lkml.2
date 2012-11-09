Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2KIJf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:35:26 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:39007 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976Ab2KIJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:35:23 -0500
Date: Fri, 9 Nov 2012 17:35:16 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jamie Iles <jamie@jamieiles.com>, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: picoxcell: Add terminating entry for
 platform_device_id table
Message-ID: <20121109093516.GD25720@gondor.apana.org.au>
References: <1352043385.11324.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352043385.11324.4.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 11:36:25PM +0800, Axel Lin wrote:
> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
