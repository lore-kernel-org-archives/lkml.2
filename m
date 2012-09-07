Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2IGTjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:39:20 -0400
Received: from [216.32.181.186] ([216.32.181.186]:45917 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755459Ab2IGTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:39:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1202hzzz2dh2a8h668h839hd25he5bhf0ah107ah1288h12a5h12a9h1155h)
Message-ID: <504A4D02.8050709@freescale.com>
Date: Fri, 7 Sep 2012 14:37:38 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Sept 4 (drivers/net/phy/mdio-mux-mmioreg.c)
References: <20120904171330.f6b0a922a754ba0f3acc123b@canb.auug.org.au> <5046933A.6080400@xenotime.net>
In-Reply-To: <5046933A.6080400@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> drivers/net/phy/mdio-mux-mmioreg.c: In function 'mdio_mux_mmioreg_probe':
> drivers/net/phy/mdio-mux-mmioreg.c:83:2: error: implicit declaration of function 'of_address_to_resource'

I can't reproduce the problem, but I think I have a fix.  I'll post a
patch in a minute.  Can you test it and let me know (e.g. via an ACK)
whether it works?

-- 
Timur Tabi
Linux kernel developer at Freescale

