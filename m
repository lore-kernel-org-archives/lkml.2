Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0JKDW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 23:22:29 -0400
Received: from kroah.org ([198.145.64.141]:60505 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0JKDW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 23:22:26 -0400
Date: Sun, 10 Oct 2010 13:29:21 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Harsha Priya <priya.harsha@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>
Subject: Re: linux-next: Tree for October 8 (staging/intel_sst)
Message-ID: <20101010202921.GB4900@kroah.com>
References: <20101008161552.07c9f137.sfr@canb.auug.org.au> <20101010115618.b048a89e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010115618.b048a89e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 11:56:18AM -0700, Randy Dunlap wrote:
> On Fri, 8 Oct 2010 16:15:52 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20101007:
> 
> 
> drivers/staging/intel_sst/intel_sst_drv_interface.c:88: error: implicit declaration of function 'msleep'
> 
> needs
> #include <linux/delay.h>

Care to send a patch?

thanks,

greg k-h
