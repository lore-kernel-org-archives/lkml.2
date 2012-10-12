Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab2JLLxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:53:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46821 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab2JLLxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:53:41 -0400
Date: Fri, 12 Oct 2012 07:54:37 -0400
From: Matt Porter <mporter@ti.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v2 08/16] ARM: omap: add hsmmc am33xx specific init
Message-ID: <20121012115437.GG13724@beef>
References: <1349982281-10785-1-git-send-email-mporter@ti.com>
 <1349982281-10785-9-git-send-email-mporter@ti.com>
 <1BAFE6F6C881BF42822005164F1491C33EAA6374@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EAA6374@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 09:17:53AM +0000, Hebbar, Gururaja wrote:
> Matt
> 
> On Fri, Oct 12, 2012 at 00:34:33, Porter, Matt wrote:
> > AM33xx requires special handling in hsmmc initialization
> > platform glue.
> 
> Since AM335x boots mainly through DT, do we still need this patch.
> This function will be called in case of initializing hsmmc with
> Platform data. 

Yes, thanks, will drop in v3.

-Matt
