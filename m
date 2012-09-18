Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2IRQ4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:56:21 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:54695 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157Ab2IRQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:56:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/T0VblALrNG+T/8D/0tCfH
Date: Tue, 18 Sep 2012 09:55:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: Matt Porter <mporter@ti.com>, Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [REPOST PATCH v2 1/2] spi: omap2-mcspi: add pinctrl support
Message-ID: <20120918165557.GQ11762@atomide.com>
References: <1347969685-15571-1-git-send-email-mporter@ti.com>
 <50586424.9040601@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50586424.9040601@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shubhrajyoti <shubhrajyoti@ti.com> [120918 05:09]:
> On Tuesday 18 September 2012 05:31 PM, Matt Porter wrote:
> > Adds pinctrl support to support OMAP platforms that boot from DT
> > and rely on pinctrl support to set pinmuxes.
> looks good
> 
> Acked-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>
