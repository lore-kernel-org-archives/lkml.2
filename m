Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2HUSUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:20:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33023 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2HUSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:20:06 -0400
Date: Tue, 21 Aug 2012 14:20:04 -0400
From: Matt Porter <mporter@ti.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        grant.likely@secretlab.ca
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 1/3] dmaengine: add TI EDMA DMA engine driver
Message-ID: <20120821182004.GA32420@beef>
References: <1345153471-22757-1-git-send-email-mporter@ti.com>
 <1345153471-22757-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345153471-22757-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 05:44:29PM -0400, Matt Porter wrote:
> Add a DMA engine driver for the TI EDMA controller. This driver
> is implemented as a wrapper around the existing DaVinci private
> DMA implementation. This approach allows for incremental conversion
> of each peripheral driver to the DMA engine API. The EDMA driver
> supports slave transfers but does not yet support cyclic transfers.

I got my hands on a AM18x WL12xx module so I could test MMC1 and this
exposed some bugs in the driver's handling of the second EDMA controller
case. DA850/OMAP-L138/AM1x have this second EDMA controller. I've
addressed this in v2 which will be posted shortly.

I'm expecting to receive a DM646x EVM RSN so I can cover testing that
part as well.

-Matt
