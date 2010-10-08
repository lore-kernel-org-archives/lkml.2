Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0JHTgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:36:38 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:54097 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab0JHTgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:36:36 -0400
X-Greylist: delayed 2360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2010 15:36:36 EDT
Date: Fri, 8 Oct 2010 20:57:08 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20101008185708.GA4989@excalibur.local>
References: <1286556780-5610-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286556780-5610-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: Re: [PATCH 1/2] mfd: Factor out WM831x I2C I/O from the core driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, 2010-10-08 at 09:52, Mark Brown wrote:
> In preparation for the addition of SPI support for the WM831x move the I2C
> specific code into a separate file with a separate Kconfig option so the
> I2C support can be excluded from the build.

The factored out file is missing here. Makefile has a reference for wm831x-i2c,
but you seemed to have forgotten to git add it.

> Also update the 1133-EV1 PMIC module support for SMDK6410 to use the new
> symbol.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  arch/arm/mach-s3c64xx/Kconfig   |    1 +
>  drivers/mfd/Kconfig             |   14 +++--
>  drivers/mfd/Makefile            |    1 +
>  drivers/mfd/wm831x-core.c       |  138 +-------------------------------------
>  include/linux/mfd/wm831x/core.h |   12 ++++
>  5 files changed, 27 insertions(+), 139 deletions(-)

regards
Stefan Schmidt
