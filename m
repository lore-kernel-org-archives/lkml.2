Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab1BYSrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:47:17 -0500
Received: from kroah.org ([198.145.64.141]:40045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab1BYSrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:47:14 -0500
Date: Fri, 25 Feb 2011 10:45:38 -0800
From: Greg KH <greg@kroah.com>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 10/10] n_tracerouter and n_tracesink compile
 configurations.
Message-ID: <20110225184538.GA2372@kroah.com>
References: <james_p_freyensee@linux.intel.com>
 <1298570824-26085-11-git-send-email-james_p_freyensee@linux.intel.com>
 <20110225180031.GB17072@kroah.com>
 <1298659152.3156.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298659152.3156.8.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:39:12AM -0800, J Freyensee wrote:
> On Fri, 2011-02-25 at 10:00 -0800, Greg KH wrote:
> > On Thu, Feb 24, 2011 at 10:07:04AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > 
> > > This patch allows n_tracerouter and n_tracesink to be compiled and
> > > configured in the Linux kernel.
> > > 
> > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > ---
> > >  drivers/char/Kconfig |   32 ++++++++++++++++++++++++++++++++
> > 
> > Why drivers/char/Kconfig?  This should be in drivers/tty/Kconfig, right?
> > 
> > Yes, this is a recent change, see the linux-next tree for the addition
> > of this file :)
> > 
> 
> That is what I was going to ask because I did base this patch off of the
> 2.6.37 stable tree and did not see a drivers/tty/Kconfig :-O.  I figured
> the stable branch was the better choice since you own it and I need to
> go through you for my work.

You should always submit against linux-next as that's pretty close to
the tree that we would be able to apply your patches to.  We can't go
back in time and add them to 2.6.37 :)

> So I should pull from linux-next I guess to fix the changes mentioned
> this round?:
> 
> -Thomas's comments on Patch 9.
> -These issues in this patch

Yes.

thanks,

greg k-h
