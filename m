Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2IQR0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:26:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44282 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2IQR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:26:23 -0400
Date: Mon, 17 Sep 2012 13:27:54 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: Re: [PATCH v2 0/2] Add pinctrl support to omap2-mcspi
Message-ID: <20120917172754.GR27758@beef>
References: <1347902538-21208-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347902538-21208-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 01:22:16PM -0400, Matt Porter wrote:
> Changes since v1:
> 	- warns that pins are not configured by the driver rather than
> 	  exiting 
> 	- dummy states are only enabled for OMAP platforms where DT is
> 	  not populated
> 
> This series enables pinctrl support for McSPI. Platforms that boot only
> from DT and rely on pinctrl to set pinmuxes appropriately require this
> for omap2-mcspi operation.
> 
> It has been tested on AM335x BeagleBone with an Adafruit SPI LCD attached
> and regression tested on Beagleboard xM booting in the !DT case, using
> board-omap3evm.c. 
> 
> The series applies on top of Tony's dt-devel branch.

*sigh*, that's devel-dt of course.
