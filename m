Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab0KCTWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:22:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:37798 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0KCTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:22:20 -0400
Date: Wed, 3 Nov 2010 12:18:54 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: gadget: goku_udc: add registered flag bit
Message-ID: <20101103191854.GA9894@suse.de>
References: <1288807358-11813-1-git-send-email-apw@canonical.com> <20101103182314.GA8010@suse.de> <20101103191238.GI14069@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103191238.GI14069@bicker>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 09:12:38PM +0200, Dan Carpenter wrote:
> On Wed, Nov 03, 2010 at 11:23:14AM -0700, Greg KH wrote:
> > On Wed, Nov 03, 2010 at 06:02:38PM +0000, Andy Whitcroft wrote:
> > > The commit below cleaned up error handling, in part by introducing a
> > > registered flag bit.  This however was not added to the device
> > > structure leding to build failures:
> > > 
> > >   commit 319feaabb6c7ccd90da6e3207563c265da7d21ae
> > >   Author: Dan Carpenter <error27@gmail.com>
> > >   Date:   Tue Oct 5 18:55:34 2010 +0200
> > > 
> > >     usb: gadget: goku_udc: Fix error path
> > > 
> > > Add the missing registered flag bit.
> > 
> > 
> > Dan, is this patch below the correct fix?  Or should we be looking at
> > some other flag?
> > 
> 
> Yes.  This was my fault.  I forgot to send you that part of the patch.
> 
> Acked-by: Dan Carpenter <error27@gmail.com>

Thanks for the quick response, I'll queue this up.

greg k-h
