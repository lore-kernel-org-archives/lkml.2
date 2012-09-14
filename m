Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab2INP5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:57:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45268 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab2INP5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:57:11 -0400
Date: Fri, 14 Sep 2012 16:57:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        olof@lixom.net, lrg@ti.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 4/5] spi: tegra: remove support of legacy DMA driver
 based access
Message-ID: <20120914155707.GC4684@opensource.wolfsonmicro.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
 <1345126397-28864-5-git-send-email-ldewangan@nvidia.com>
 <504936AF.8010701@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504936AF.8010701@wwwdotorg.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 05:50:07PM -0600, Stephen Warren wrote:
> On 08/16/2012 08:13 AM, Laxman Dewangan wrote:

> > Remove the support code which uses the legacy APB DMA driver
> > for accessing the SPI FIFO.
> > The driver will use the dmaengine based APB DMA driver for
> > accessing reqding/writing to SPI FIFO.

> I'd like to take this patch through the Tegra tree, since it relies on
> the previous Tegra patches to convert to dmaengine. Could I please get
> an ack if that's OK? Thanks.

I don't seem to have the patch for review, not sure why.
