Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab2JLJSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:18:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57354 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2JLJSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:18:33 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
CC: Linux DaVinci Kernel List 
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
Subject: RE: [RFC PATCH v2 08/16] ARM: omap: add hsmmc am33xx specific init
Thread-Topic: [RFC PATCH v2 08/16] ARM: omap: add hsmmc am33xx specific init
Thread-Index: AQHNp+OyjmsKGgOZZ0qYPapAEWA8sJe1ZGXw
Date: Fri, 12 Oct 2012 09:17:53 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EAA6374@DBDE01.ent.ti.com>
References: <1349982281-10785-1-git-send-email-mporter@ti.com>
 <1349982281-10785-9-git-send-email-mporter@ti.com>
In-Reply-To: <1349982281-10785-9-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt

On Fri, Oct 12, 2012 at 00:34:33, Porter, Matt wrote:
> AM33xx requires special handling in hsmmc initialization
> platform glue.

Since AM335x boots mainly through DT, do we still need this patch.
This function will be called in case of initializing hsmmc with
Platform data. 

> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/mach-omap2/hsmmc.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

..snip..
..snip..

>  	name = "omap_hsmmc";
>  	res = snprintf(oh_name, MAX_OMAP_MMC_HWMOD_NAME_LEN,
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
