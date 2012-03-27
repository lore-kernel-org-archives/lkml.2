Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2C1Ena (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 00:43:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2C1En1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 00:43:27 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/5] spi: omap2-mcspi: driver updates
To: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net
Cc: Shubhrajyoti@ponder.secretlab.ca, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, D <shubhrajyoti@ti.com>
In-Reply-To: <1332769480-28069-1-git-send-email-shubhrajyoti@ti.com>
References: <1332769480-28069-1-git-send-email-shubhrajyoti@ti.com>
Date: Tue, 27 Mar 2012 15:58:38 -0600
Message-Id: <20120327215838.AB7C33E13A0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 19:14:35 +0530, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> The patch series does the following cleanups
> - Converts the spi to module_platform_driver
> - Use the devm functions so that the freeing need not 
>   be done in the driver.
> - Makes the driver use autosuspend
> - Folds Benoit's bus_num removal patch in the series
> 
> Changes from the previous version
> - Makes the driver use autosuspend
> - Folds Benoit's bus_num removal patch in the series
> 
> 
> This is also available through
> git     : git://gitorious.org/linus-tree/linus-tree.git
> branch  : spi

Hi Shubhrajyoti,

I'll queue these ones up for v3.5 unless you make the argument that
they are bug fixes that must go into v3.4.

g.
