Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3ACKEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:04:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47346 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab3ACKEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:04:34 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>
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
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Subject: RE: [RFC PATCH v3 13/16] ARM: dts: add AM33XX MMC support
Thread-Topic: [RFC PATCH v3 13/16] ARM: dts: add AM33XX MMC support
Thread-Index: AQHNrTTEmw6hAekvsk24D3QH23WgXZg318Hw
Date: Thu, 3 Jan 2013 10:03:43 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB3402D@DBDE01.ent.ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-14-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-14-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Thu, Oct 18, 2012 at 18:56:52, Porter, Matt wrote:
> Adds AM33XX MMC support for am335x-bone and am335x-evm.

I want to test Suspend/Resume feature on omap hsmmc driver. 
Do you any tree based on mainline kernel v3.8-rc1 with these edma & mmc
patches.

> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/boot/dts/am335x-bone.dts |    6 ++++++
>  arch/arm/boot/dts/am335x-evm.dts  |    6 ++++++
>  arch/arm/boot/dts/am33xx.dtsi     |   27 +++++++++++++++++++++++++++
>  3 files changed, 39 insertions(+)
> 

..snip..
..snip..
..snip..


Regards, 
Gururaja
