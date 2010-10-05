Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab0JETLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:11:22 -0400
Received: from kroah.org ([198.145.64.141]:39007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab0JETLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:11:18 -0400
Date: Tue, 5 Oct 2010 12:08:18 -0700
From: Greg KH <greg@kroah.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: Re: linux-next: Tree for October 1 (staging/olpc_dcon)
Message-ID: <20101005190818.GD20825@kroah.com>
References: <20101001153756.47b52566.sfr@canb.auug.org.au>
 <20101001154531.997630a2.randy.dunlap@oracle.com>
 <20101001192454.0a427cb0@debxo>
 <20101002185154.GA18020@suse.de>
 <20101002180334.7894bdfe@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101002180334.7894bdfe@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 06:03:34PM -0700, Andres Salomon wrote:
> On Sat, 2 Oct 2010 11:51:54 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Fri, Oct 01, 2010 at 07:24:54PM -0700, Andres Salomon wrote:
> > > On Fri, 1 Oct 2010 15:45:31 -0700
> > > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > > > On Fri, 1 Oct 2010 15:37:56 +1000 Stephen Rothwell wrote:
> > > > 
> > > > > Hi all,
> > > > > 
> > > > > Changes since 20100930:
> > > > 
> > > > 
> > > > drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:57: error: implicit
> > > > declaration of function 'geode_gpio_event_irq'
> > > > drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:57: error: implicit
> > > > declaration of function 'geode_gpio'
> > > 
> > > Yep, it's pending a cs5535-gpio patch
> > > (https://patchwork.kernel.org/patch/209482/).
> > 
> > Wait, as I didn't apply the later patches, what I did apply should
> > have still built properly (remember our rule, no breakage at any
> > point in a patch series.)  So, should I revert the last olpc patch
> > that caused this problem?
> > 
> 
> Sorry, I thought that was made clear by the "this patch is necessary
> for building the driver" comments in each patch description.  The
> original driver that was submitted doesn't build unless all patches are
> applied (the only which touches external APIs is the pending
> cs5535-gpio one).

Ok, I'll go mark the driver as depending on CONFIG_BROKEN for now, until
we get that resolved, as we can't have a driver that breaks the build in
the tree.

thanks,

greg k-h
