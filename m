Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0JBSyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 14:54:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0JBSyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 14:54:16 -0400
Date: Sat, 2 Oct 2010 11:51:54 -0700
From: Greg KH <gregkh@suse.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: Re: linux-next: Tree for October 1 (staging/olpc_dcon)
Message-ID: <20101002185154.GA18020@suse.de>
References: <20101001153756.47b52566.sfr@canb.auug.org.au> <20101001154531.997630a2.randy.dunlap@oracle.com> <20101001192454.0a427cb0@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001192454.0a427cb0@debxo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 07:24:54PM -0700, Andres Salomon wrote:
> On Fri, 1 Oct 2010 15:45:31 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Fri, 1 Oct 2010 15:37:56 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20100930:
> > 
> > 
> > drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:57: error: implicit
> > declaration of function 'geode_gpio_event_irq'
> > drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:57: error: implicit
> > declaration of function 'geode_gpio'
> 
> Yep, it's pending a cs5535-gpio patch
> (https://patchwork.kernel.org/patch/209482/).

Wait, as I didn't apply the later patches, what I did apply should have
still built properly (remember our rule, no breakage at any point in a
patch series.)  So, should I revert the last olpc patch that caused this
problem?

thanks,

greg k-h
