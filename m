Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1FGRQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:16:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41045 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1FGRQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SV4XO4JK07r4weqpP8I3LhZfVKQx/TtRbMl57ELUekfGla7/UhaFPHto+WfXaREasN
         Nh+jOfWP6mJVDFmZ7ySqd5c896oi0yF6iGz4fNnjBzgoh4gUL3iNDjnIaELmGd6hjG8b
         Y2BBCVf2nfuG6CHbHCUV4oQ9e3cPeTS6shv2Q=
Date: Tue, 7 Jun 2011 20:14:04 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        rmallon@gmail.com, vinod.koul@intel.com, dan.j.williams@intel.com,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] spi/ep93xx: add DMA support
Message-ID: <20110607171403.GA3011@acer>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <4b27fc93b7df900943e7c12084a8340cbc5fe1a8.1306662317.git.mika.westerberg@iki.fi>
 <20110603204400.GH17972@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603204400.GH17972@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 02:44:00PM -0600, Grant Likely wrote:
> On Sun, May 29, 2011 at 01:10:06PM +0300, Mika Westerberg wrote:
> > This patch adds DMA support for the EP93xx SPI driver. By default the DMA is
> > not enabled but it can be enabled by setting ep93xx_spi_info.use_dma to true
> > in board configuration file.
> > 
> > Note that the SPI driver still uses PIO for small transfers (<= 8 bytes) for
> > performance reasons.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> > Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Since this depends on the DMA patches, it can go in via the same tree.

I just realized that once the SPI driver renaming patch (spi: reorganize
drivers) enters linux-next, this patch (which sits on Vinod's tree) will cause
a merge conflict. Any ideas how to avoid it beforehand?
