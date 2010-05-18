Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab0ERVbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:31:50 -0400
Received: from kroah.org ([198.145.64.141]:56858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0ERVbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:31:48 -0400
Date: Tue, 18 May 2010 14:28:59 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Kurz <linux@blala.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Kconfig dependancy fixes
Message-ID: <20100518212859.GA26944@kroah.com>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de>
 <20100514190142.GA2505@kroah.com>
 <alpine.DEB.1.10.1005151604320.26254@blala.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1005151604320.26254@blala.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 04:09:01PM +0400, Alexander Kurz wrote:
> There are tree minor changes I would like to do on my last patch:
> > Subject: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped by bustype.
> 
> * Comedi is formally not dependant on any hardware, e.g. it is possible
>  to use comedi_test without (PCI || PCMCIA || PCCARD || USB || ISA)
> * comedi_parport is not dependant on PARPORT_PC.
> * indirect ni_mio_cs (16-bit PCMCIA) dependancy on mite PCI-chip may 
>  confuse users, thus changing COMEDI_NI_TIO depends on COMEDI_MITE
>  to select COMEDI_MITE.

I'll go apply this, but I still get a build error, and need to include
the 8255.o module when building some PCI drivers and not the ISA ones.

Care to fix that up?

thanks,

greg k-h
