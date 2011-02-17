Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab1BQTph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:45:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:33496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887Ab1BQTpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:45:36 -0500
Date: Thu, 17 Feb 2011 11:45:12 -0800
From: Greg KH <gregkh@suse.de>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
Subject: Re: [PATCH 04/12] PTI Kconfig change in misc.
Message-ID: <20110217194512.GA31725@suse.de>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <20110217192038.GB29448@kroah.com>
 <1297971351.3038.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297971351.3038.22.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:35:51AM -0800, J Freyensee wrote:
> On Thu, 2011-02-17 at 11:20 -0800, Greg KH wrote:
> > On Tue, Feb 08, 2011 at 11:34:49AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > 
> > > This adds the Intel PTI Kconfig option.
> > > 
> > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > ---
> > >  drivers/misc/Kconfig |   12 ++++++++++++
> > >  1 files changed, 12 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > index 4d073f1..f8076f1 100644
> > > --- a/drivers/misc/Kconfig
> > > +++ b/drivers/misc/Kconfig
> > > @@ -136,6 +136,18 @@ config PHANTOM
> > >  	  If you choose to build module, its name will be phantom. If unsure,
> > >  	  say N here.
> > >  
> > > +config INTEL_MID_PTI
> > 
> > Don't add new Kconfig options when there is no code for it yet to use
> > it.  Merge this with the Makefile patch.
> > 
> 
> I do not quite understand the problem.  The code for this Kconfig is
> ~/drivers/misc/pti.c and it was patch 3/12.  I tested that in 'make
> menuconfig' the kernel turns the compile option on and off fine.
> 
> What needs to be fixed here?

Merge it with your Makefile patch, it doesn't need to be separate.

thanks,

greg k-h
