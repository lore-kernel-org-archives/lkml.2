Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0CXP5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:57:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:57740 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab0CXP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:57:44 -0400
Date: Wed, 24 Mar 2010 08:49:16 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
Subject: Re: [PATCH 1/7] serial: TTY: new ldisc for TI BT/FM/GPS chips
Message-ID: <20100324154916.GA8579@suse.de>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com> <1269376875-25940-2-git-send-email-pavan_savoy@ti.com> <20100324022803.GA4359@suse.de> <20100324084307.2a07dbb1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324084307.2a07dbb1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 08:43:07AM +0000, Alan Cox wrote:
> On Tue, 23 Mar 2010 19:28:03 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Tue, Mar 23, 2010 at 03:41:09PM -0500, pavan_savoy@ti.com wrote:
> > > From: Pavan Savoy <pavan_savoy@ti.com>
> > > 
> > > A new N_TI_WL line discipline added for TI BT/FM/GPS
> > > combo chips which make use of same TTY to communicate
> > > with chip. This is to be made use of individual protocol
> > > BT/FM/GPS drivers.
> > > 
> > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > ---
> > >  include/linux/tty.h |    3 ++-
> > 
> > Staging code needs to be completly self-contained in the drivers/staging
> > directory.  Is there any way to do this without touching this file?
> 
> Put the N_TI_WL into a staging header, and bump the number of ldiscs as a
> separate non staging patch - we should probably simply bump it a bit
> anyway to leave room for experimental work using a built kernel image.
> There is no requirement that the number of ldiscs matches up to the last
> ldisc assigned.

That sounds good to me.

thanks,

greg k-h
