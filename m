Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab1DMXZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:25:11 -0400
Received: from kroah.org ([198.145.64.141]:39799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781Ab1DMXZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:25:10 -0400
Date: Wed, 13 Apr 2011 16:23:15 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Chris Wright <chrisw@sous-sol.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] usb: core: Change usb_create_sysfs_intf_files()'
 return type to void
Message-ID: <20110413232315.GA9949@kroah.com>
References: <531a6364dd1220278e76479423ce697e32bf4082.1301003830.git.mina86@mina86.com>
 <Pine.LNX.4.44L0.1103251302410.2047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1103251302410.2047-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 01:03:12PM -0400, Alan Stern wrote:
> On Fri, 25 Mar 2011, Michal Nazarewicz wrote:
> 
> > The usb_create_sysfs_intf_files() function always returned zero even
> > if it failed to create sysfs fails.  Since this is a desired behaviour
> > there is no need to return return code at all.  This commit changes
> > function's return type (form int) to void.
> > 
> > Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> > Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >  drivers/usb/core/sysfs.c |   13 +++++--------
> >  drivers/usb/core/usb.c   |    3 +--
> >  drivers/usb/core/usb.h   |    2 +-
> >  3 files changed, 7 insertions(+), 11 deletions(-)
> > 
> > On Fri, 25 Mar 2011 16:33:12 +0100, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > My style preference is to put the empty statement before the comment.
> > > It's unusual to have a comment appearing before a statement on the same
> > > line.  For example:
> > >		;	/* We don't care if the function fails */
> > 
> > Changed.  And I agree, it looks better now. :)
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

I can't find this version of the patch in my email archive anywhere.

Michal, can you resend it so I can apply it?

thanks,

greg k-h
