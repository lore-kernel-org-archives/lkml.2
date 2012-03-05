Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2CEWOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:14:08 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:43479 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2CEWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:14:05 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Zzq1ak4oO4dJE379Ugbc1
Date: Mon, 5 Mar 2012 14:13:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, Russell King <linux@arm.linux.org.uk>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-omap2/: included some headers twice
Message-ID: <20120305221357.GA12083@atomide.com>
References: <1329403502-32494-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329403502-32494-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Danny Kukawka <danny.kukawka@bisect.de> [120216 06:13]:
> arch/arm/mach-omap2/: included some headers tiwce:
> - arch/arm/mach-omap2/board-ldp.c: 'linux/gpio.h'
> - arch/arm/mach-omap2/io.c: 'common.h'
> - arch/arm/mach-omap2/omap_hwmod_44xx_data.c: 'plat/i2c.h'
> 
> Remove the duplicates.

Thanks applying this too.

Regards,

Tony
