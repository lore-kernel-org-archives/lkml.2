Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0C3UjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:39:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab0C3UjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:39:10 -0400
Date: Tue, 30 Mar 2010 13:38:42 -0700
From: Greg KH <gregkh@suse.de>
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: sources for ST core
Message-ID: <20100330203842.GA5850@suse.de>
References: <20100330122201.02accf0f@lxorguk.ukuu.org.uk> <693134.37568.qm@web94902.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693134.37568.qm@web94902.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:23:23PM +0530, Pavan Savoy wrote:
> Alan,
> 
> --- On Tue, 30/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Subject: Re: [PATCH] drivers:staging: sources for ST core
> > To: pavan_savoy@ti.com
> > Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
> > Date: Tuesday, 30 March, 2010, 4:52 PM
> > > +/* all debug macros go in here
> > */
> > > +#define ST_DRV_ERR(fmt, arg...)? printk(KERN_ERR
> > "(stc):"fmt"\n" , ## arg)
> > > +#if defined(DEBUG)???
> > ??? /* limited debug messages */
> > > +#define ST_DRV_DBG(fmt, arg...)?
> > printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> > > +#define ST_DRV_VER(fmt, arg...)
> > > +#elif defined(VERBOSE)???
> > ??? /* very verbose */
> > > +#define ST_DRV_DBG(fmt, arg...)?
> > printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> > > +#define ST_DRV_VER(fmt, arg...)?
> > printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> > > +#else /* error msgs only */
> > > +#define ST_DRV_DBG(fmt, arg...)
> > > +#define ST_DRV_VER(fmt, arg...)
> > > +#endif
> > 
> > As Greg said earlier - needs to be using the standard debug
> > macros
> 
> Agree - It's all there because of the organization's coding standards.
> Will correct it.

Might you also want to correct your organization's coding standards to
follow the correct Linux kernel ones?  That way you will not have this
problem in the future.

thanks,

greg k-h
