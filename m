Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab2CTQU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:20:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42423 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab2CTQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:20:24 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/3] SPI updates
To: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net
Cc: Shubhrajyoti@ponder.secretlab.ca, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, D <shubhrajyoti@ti.com>
In-Reply-To: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
References: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
Date: Tue, 20 Mar 2012 16:20:18 +0000
Message-Id: <20120320162019.33AC83E2834@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012 15:59:46 +0530, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> The patch series does the following cleanups
> - Converts the spi to module_platform_driver
> - Use the devm functions so that the freeing need not 
>   be done in the driver.
> 
> This is also available through
> git     : git://gitorious.org/linus-tree/linus-tree.git
> branch  : spi
> 
> 
> Felipe Balbi (2):
>   spi: omap2-mcspi: make it behave as a module
>   spi: omap2-mcspi: convert to module_platform_driver
> 
> Shubhrajyoti D (1):
>   spi: omap2-mcspi: use devm_* functions
> 
>  drivers/spi/spi-omap2-mcspi.c |   46 ++++++++---------------------------------
>  1 files changed, 9 insertions(+), 37 deletions(-)

Merged for v3.5 (it's too late for v3.4)

g.

