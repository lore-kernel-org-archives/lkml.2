Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0CXCtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:49:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab0CXCtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:49:52 -0400
Date: Tue, 23 Mar 2010 19:48:30 -0700
From: Greg KH <gregkh@suse.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: pavan_savoy@ti.com, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH 1/7] serial: TTY: new ldisc for TI BT/FM/GPS chips
Message-ID: <20100324024830.GA4642@suse.de>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com> <1269376875-25940-2-git-send-email-pavan_savoy@ti.com> <1269397490.11714.104.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269397490.11714.104.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 07:24:50PM -0700, Marcel Holtmann wrote:
> > +#define N_TI_WL	20	/* for TI's WL connectivity chips */
> >  
> >  /*
> >   * This character is the same as _POSIX_VDISABLE: it cannot be used as
> 
> why is this even targeting staging. I prefer if we have proper review
> cycles and get this reviewed this way. This looks like more a shortcut
> to get things into the kernel than actually spending the effort to clean
> things up.
> 
> If this would be just a driver, I wouldn't care, but it tries to assign
> official numbers for a line discipline and clearly collides with other
> peoples work that are going the proper upstream review cycles.
> 
> Greg, I would like to see the rule that if it touches files outside of
> drivers/staging/ then it is not eligible for staging.

That is a rule already :)

See my complaint about this a few minutes ago.

thanks,

greg k-h
