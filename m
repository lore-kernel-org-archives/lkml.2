Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1LIAt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:49:57 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26795 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751238Ab1LIAtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:49:53 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/mWF/jJC0levYOyd3OpOUB
Date: Thu, 8 Dec 2011 16:49:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] OMAP2, 3: DSS2: Include linux/delay.h and common.h to
 fix build errors
Message-ID: <20111209004951.GK31337@atomide.com>
References: <1322654481.11191.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322654481.11191.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Axel Lin <axel.lin@gmail.com> [111130 03:26]:
> Include linux/delay.h to fix below build error:
> 
>   CC      arch/arm/mach-omap2/display.o
> arch/arm/mach-omap2/display.c: In function 'dispc_disable_outputs':
> arch/arm/mach-omap2/display.c:283: error: implicit declaration of function 'mdelay'
> arch/arm/mach-omap2/display.c: In function 'omap_dss_reset':
> arch/arm/mach-omap2/display.c:317: error: implicit declaration of function 'omap_test_timeout'
> make[1]: *** [arch/arm/mach-omap2/display.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2
> 
> Include common.h to fix below build error:
> 
>   CC      arch/arm/mach-omap2/display.o
> arch/arm/mach-omap2/display.c: In function 'omap_dss_reset':
> arch/arm/mach-omap2/display.c:318: error: implicit declaration of function 'omap_test_timeout'
> make[1]: *** [arch/arm/mach-omap2/display.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I got the build error on linux-next 20111130.
> This patch is against linux-next 20111130.
> Axel

Thanks we already have commit deee6d5359969a0ce4e2760cfd7b9f379bd5698a
in Russell's devel-stable branch doing the same thing.

Regards,

Tony
