Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab0ENTRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:17:47 -0400
Received: from kroah.org ([198.145.64.141]:57247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0ENTRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:17:46 -0400
Date: Fri, 14 May 2010 12:01:42 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Kurz <linux@blala.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers
 grouped by bustype.
Message-ID: <20100514190142.GA2505@kroah.com>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1005081218220.5727@blala.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 08, 2010 at 12:21:45PM +0400, Alexander Kurz wrote:
> This is a new Kconfig and Makefikes for staging/comedi.
> The drivers are sorted now alphabetically in sub-menus
> depending on the bustype.
> I did some basiy dependancy tests, but there still may
> be a lot that I missed.
> 
> >From c53596606230a4a8ee7dd76b48cf6b10a059e8f7 Mon Sep 17 00:00:00 2001
> From: Alexander Kurz <linux@kbdbabel.org>
> Date: Fri, 7 May 2010 22:46:17 +0200
> Subject: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped by bustype.
>  PC/104-drivers went into ISA,
>  PC/104+ went into PCI,
>  Drivers without a bustype went into "misc".
>  In doubt drivers supporting both ISA/PCI went into PCI.
>  Drivers without any detailed hardware info went into ISA, e.g. fl512.c
>  Some NI drivers are used by other NI drivers from different bustypes
>  are grouped seperately in NI_COMMON.
> 
> Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
> ---
>  drivers/staging/comedi/Kconfig             | 1274 +++++++++++++++++++++++++++-
>  drivers/staging/comedi/drivers/Makefile    |  245 +++---
>  drivers/staging/comedi/kcomedilib/Makefile |    2 +-

Wow.  Is this something that we really want?  That's a lot of new
Kconfig options, and while it seems like it makes sense, I would like to
get the comedi developers opinion here.

Frank?  Ian?

thanks,

greg k-h
