Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1KZRzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 12:55:45 -0500
Received: from chipmunk.wormnet.eu ([195.195.131.226]:32807 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab1KZRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 12:55:44 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Nov 2011 12:55:44 EST
Date: Sat, 26 Nov 2011 17:48:35 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jamie Iles <jamie@jamieiles.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] char: hw_random: convert drivers/char/hw_random/* to
 use module_platform_driver()
Message-ID: <20111126174834.GK6177@chipmunk>
References: <1322313066.6001.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322313066.6001.3.camel@phoenix>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Axel Lin <axel.lin@gmail.com> [2011-11-26 21:11:06+0800]:
>
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
>
Acked-by: Alexander Clouter <alex@digriz.org.uk>

Cheers

-- 
Alexander Clouter
.sigmonster says: If you are too busy to read, then you are too busy.
