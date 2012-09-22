Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2IVQGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 12:06:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58355 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab2IVQGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 12:06:47 -0400
Date: Sat, 22 Sep 2012 12:06:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Porter <mporter@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: Re: [REPOST PATCH v2 1/2] spi: omap2-mcspi: add pinctrl support
Message-ID: <20120922160643.GS4495@opensource.wolfsonmicro.com>
References: <1347969685-15571-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347969685-15571-1-git-send-email-mporter@ti.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:01:25AM -0400, Matt Porter wrote:
> Adds pinctrl support to support OMAP platforms that boot from DT
> and rely on pinctrl support to set pinmuxes.

Applied, thanks.
