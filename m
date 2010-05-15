Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0EODnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 23:43:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab0EODns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 23:43:48 -0400
Date: Fri, 14 May 2010 20:44:23 -0700
From: Greg KH <gregkh@suse.de>
To: fmhess@users.sourceforge.net
Cc: Greg KH <greg@kroah.com>, Alexander Kurz <linux@blala.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers
	grouped by bustype.
Message-ID: <20100515034423.GA3811@suse.de>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com> <201005142029.37408.fmhess@speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005142029.37408.fmhess@speakeasy.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 08:29:33PM -0400, Frank Mori Hess wrote:
> On Friday 14 May 2010, Greg KH wrote:
> > Wow.  Is this something that we really want?  That's a lot of new
> > Kconfig options, and while it seems like it makes sense, I would like to
> > get the comedi developers opinion here.
> 
> It doesn't matter to me how granular the Kconfig stuff is.  Personally, the 
> only thing I tend to do is disable are the pcmcia drivers as a group on 
> desktop machines.  Also, I noticed in the patch it includes the 8255 
> module as part of the PCI and ISA groups, but not PCMCIA.  But it is used 
> by some of the PCMCIA drivers as well.

Ok, I'll queue this up.  Alex can you send a follow-on patch to fix up
the 8255 stuff?

thanks,

greg k-h
