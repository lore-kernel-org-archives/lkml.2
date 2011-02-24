Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1BXRNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:13:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab1BXRND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:13:03 -0500
Date: Thu, 24 Feb 2011 09:12:09 -0800
From: Greg KH <gregkh@suse.de>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: alan@linux.intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gma500: Fix compilation error.
Message-ID: <20110224171209.GE7925@suse.de>
References: <1298539998-6422-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298539998-6422-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:33:18AM +0100, Marek Belisko wrote:
> This patch will fix following compilation error:
> drivers/staging/gma500/psb_drv.c:1635: error: unknown field ‘pci_driver’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1636: error: unknown field ‘name’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1636: warning: initialization from incompatible pointer type
> drivers/staging/gma500/psb_drv.c:1637: error: unknown field ‘id_table’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1637: warning: excess elements in union initializer
> drivers/staging/gma500/psb_drv.c:1637: warning: (near initialization for ‘driver.kdriver’)
> drivers/staging/gma500/psb_drv.c:1638: error: unknown field ‘resume’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1638: warning: excess elements in union initializer
> drivers/staging/gma500/psb_drv.c:1638: warning: (near initialization for ‘driver.kdriver’)
> drivers/staging/gma500/psb_drv.c:1639: error: unknown field ‘suspend’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1639: warning: excess elements in union initializer
> drivers/staging/gma500/psb_drv.c:1639: warning: (near initialization for ‘driver.kdriver’)
> drivers/staging/gma500/psb_drv.c:1640: error: unknown field ‘probe’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1640: warning: excess elements in union initializer
> drivers/staging/gma500/psb_drv.c:1640: warning: (near initialization for ‘driver.kdriver’)
> drivers/staging/gma500/psb_drv.c:1641: error: unknown field ‘remove’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1641: warning: excess elements in union initializer
> drivers/staging/gma500/psb_drv.c:1641: warning: (near initialization for ‘driver.kdriver’)
> drivers/staging/gma500/psb_drv.c:1643: error: unknown field ‘driver’ specified in initializer
> drivers/staging/gma500/psb_drv.c:1643: warning: excess elements in union initializer
> drivers/staging/gma500/psb_drv.c:1643: warning: (near initialization for ‘driver.kdriver’)
> drivers/staging/gma500/psb_drv.c: In function ‘psb_init’:
> drivers/staging/gma500/psb_drv.c:1664: error: implicit declaration of function ‘drm_init’
> drivers/staging/gma500/psb_drv.c: In function ‘psb_exit’:
> drivers/staging/gma500/psb_drv.c:1669: error: implicit declaration of function ‘drm_exit’
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

Odd, how come I'm not hitting these in the staging-next tree?  Is it
because an api changed in the DRM layer in the linux-next tree?

thanks,

greg k-h
