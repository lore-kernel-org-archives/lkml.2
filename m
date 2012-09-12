Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab2ILNwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:52:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38678 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758620Ab2ILNwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:52:53 -0400
Date: Wed, 12 Sep 2012 21:52:41 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Cleanup the omap2_mcspi_txrx_dma
 function
Message-ID: <20120912135239.GE19055@opensource.wolfsonmicro.com>
References: <1347345800-4116-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347345800-4116-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 12:13:20PM +0530, Shubhrajyoti D wrote:
> Currently in omap2_mcspi_txrx_dma the tx and the rx support is
> interleaved. Make the rx related code in omap2_mcspi_rx_dma
> and the tx related code omap2_mcspi_tx_dma and call the functions.

Applied, thanks.
