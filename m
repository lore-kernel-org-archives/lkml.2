Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1K1Mtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:49:43 -0500
Received: from vm4.telegraphics.com.au ([98.124.60.149]:37810 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1K1Mtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:49:42 -0500
Date: Mon, 28 Nov 2011 23:49:35 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Axel Lin <axel.lin@gmail.com>
cc: linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: convert drivers/scsi/* to use
 module_platform_driver()
In-Reply-To: <1322315527.15832.1.camel@phoenix>
Message-ID: <alpine.LNX.2.00.1111282345090.26744@nippy.intranet>
References: <1322315527.15832.1.camel@phoenix>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Nov 2011, Axel Lin wrote:

> This patch converts the drivers in drivers/scsi/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
...
>  
> -static int __init jazz_esp_init(void)
...
> +module_platform_driver(esp_jazz_driver);

Doesn't this transform "jazz_esp_init" into "jazz_esp_driver_init"?

If that's the convention, it seems odd that the module_platform_driver 
macro doesn't do it...

Finn
