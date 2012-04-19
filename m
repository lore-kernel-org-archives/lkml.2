Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2DSGUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:20:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46429 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2DSGUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:20:48 -0400
Date: Thu, 19 Apr 2012 09:19:53 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Hannu Heikkinen <hannuxx@iki.fi>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi/ep93xx: clean probe/remove routines
Message-ID: <20120419061953.GD18520@mwesterb-mobl.lan>
References: <1334752571-24627-1-git-send-email-hannuxx@iki.fi>
 <ADE657CA350FB648AAC2C43247A983F00206987A41FD@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206987A41FD@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 11:09:18AM -0500, H Hartley Sweeten wrote:
> But, I really don't think we actually gain anything by displaying the
> memory and irq. Maybe this would be more useful:
> 
> 	dev_info(&pdev->dev, "EP93xx SPI Controller using %s\n",
> 		 espi->dma_tx ? "DMA" : "PIO");
> 
> That way the user knows at boot time if the spi controller is using DMA or PIO.
> 
> Mika, what do you think?

I agree, having the driver to print whether DMA or PIO is used brings more
value than it is currently doing. However, that is a subject of a separate
patch not this one.
