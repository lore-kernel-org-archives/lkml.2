Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0CXC0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:26:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:60451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab0CXC0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:26:05 -0400
Date: Tue, 23 Mar 2010 19:19:58 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: pavan_savoy@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
Message-ID: <20100324021958.GA4254@suse.de>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com> <1269292756-7469-2-git-send-email-pavan_savoy@ti.com> <1269292756-7469-3-git-send-email-pavan_savoy@ti.com> <20100322213530.GC420@suse.de> <20100323151852.7c4c30b7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323151852.7c4c30b7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:18:52PM +0000, Alan Cox wrote:
> On Mon, 22 Mar 2010 14:35:30 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Mon, Mar 22, 2010 at 04:19:12PM -0500, pavan_savoy@ti.com wrote:
> > > From: Pavan Savoy <pavan_savoy@ti.com>
> > > 
> > > This change adds the Kconfig and Make file for TI's
> > > ST line discipline driver and the BlueZ driver for BT
> > > core of the TI BT/FM/GPS combo chip.
> > > 
> > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > ---
> > >  drivers/misc/Kconfig        |    1 +
> > 
> > Why 'misc'?  Why not 'char' like all the other ldiscs?
> > 
> > Or 'drivers/ldisc' to be more specific?
> 
> We've discussed having /tty or drivers/tty for a while. The ldiscs are
> currently everywhere - drivers/net, isdn, char ....
> 
> I am not sure an ldisc directory helps though - slip and ppp are in
> drivers/net for example and clearly belong there.

Yeah, good point.  I like the idea of a tty/ directory for the tty core
in the future if it's really needed.

thanks,

greg k-h
