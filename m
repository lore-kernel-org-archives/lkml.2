Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2BWO0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2BWO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:08 -0500
Date: Thu, 23 Feb 2012 09:26:13 -0500
From: Matt Porter <mporter@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120223142612.GA13407@beef>
References: <1329929103-28486-1-git-send-email-mporter@ti.com>
 <79CD15C6BA57404B839C016229A409A8317DA6CD@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79CD15C6BA57404B839C016229A409A8317DA6CD@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 12:08:34PM +0000, Hiremath, Vaibhav wrote:
> On Wed, Feb 22, 2012 at 22:15:03, Porter, Matt wrote:
> >  /*
> >   * Initialize smsc911x device connected to the GPMC. Note that we
> >   * assume that pin multiplexing is done in the board-*.c file,
> > @@ -51,10 +97,16 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
> >  {
> >  	struct platform_device *pdev;
> >  	unsigned long cs_mem_base;
> > -	int ret;
> > +	int ret, err;
> >  
> 
> Do you really need another variable here? Can't you use "ret" here?

No we don't, thanks for catching this. I posted a v3 that addresses it.

Tony: can you revert v2 for v3 that I just posted which addresses
Vaibhav's comment?

-Matt
