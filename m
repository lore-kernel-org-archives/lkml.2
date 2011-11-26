Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1KZOyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 09:54:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1KZOyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 09:54:39 -0500
Date: Sat, 26 Nov 2011 14:54:42 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Clouter <alex@digriz.org.uk>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jamie Iles <jamie@jamieiles.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] char: hw_random: convert drivers/char/hw_random/* to use
 module_platform_driver()
Message-ID: <20111126145442.GC28582@gallagher>
References: <1322313066.6001.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322313066.6001.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Acked-by: Jamie Iles <jamie@jamieiles.com>

Thanks Axel!
