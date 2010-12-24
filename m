Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0LXCAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 21:00:37 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44375 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0LXCAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 21:00:35 -0500
Date: Fri, 24 Dec 2010 10:58:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-arch@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>,
        linux-sh@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Message-ID: <20101224015858.GG28151@linux-sh.org>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012240020.37208.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 12:20:32AM +0100, Janusz Krzysztofik wrote:
> Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera patch, 
> patterned upon two mach-mx3 machine types which already try to use the 
> dma_declare_coherent_memory() method for reserving a region of system 
> RAM preallocated with another dma_alloc_coherent(). Compile tested for 
> all modified files except arch/sh/drivers/pci/fixups-dreamcast.c.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

The arch/sh/drivers/pci/fixups-dreamcast.c build fine.

Acked-by: Paul Mundt <lethal@linux-sh.org>
