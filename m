Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2LSNTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:19:05 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45504 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2LSNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:18:55 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH - v2] spi: davinci: add OF support for the spi controller
To: Murali Karicheri <m-karicheri2@ti.com>, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-keystone@list.ti.com
Cc: Murali Karicheri <m-karicheri2@ti.com>
In-Reply-To: <20121215002758.14D223E0BEC@localhost>
References: <1355260839-29865-1-git-send-email-m-karicheri2@ti.com> <20121215002758.14D223E0BEC@localhost>
Date: Wed, 19 Dec 2012 13:18:50 +0000
Message-Id: <20121219131850.E421B3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2012 00:27:58 +0000, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, 11 Dec 2012 16:20:39 -0500, Murali Karicheri <m-karicheri2@ti.com> wrote:
> > This adds OF support to DaVinci SPI controller to configure platform
> > data through device bindings. Also replaces clk_enable() with
> > of clk_prepare_enable() as well as clk_disable() with
> > clk_disable_unprepare().
> > 
> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> > Reviewed-by : Grant Likely <grant.likely@secretlab.ca>
> 
> Applied, thanks.
> 
> I did remove the OF_ALIAS_N property though. I know the COMPATIBLE one
> uses it, but it is actually kind of redundant since it can also be
> determined by counting the number of OF_ALIAS_* entries, and having the
> _N one in there means extra work needs to be done to filter it out.
> 
> Also, I had to add a #ifndef _LINUX_OF_PRIVATE_H wrapper around the
> whole header file. This is needed for all header files to protect
> against multiple includes.

Ummm.... oops. I replied to the wrong email when applying another patch.
Sorry for the noise.

But I have applied your patch now. It will appear in linux-next after
the merge window closes.

g.

