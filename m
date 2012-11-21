Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2KVUIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:08:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63518 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab2KVUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:08:50 -0500
Date: Wed, 21 Nov 2012 14:11:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kumar amit mehta <gmate.amit@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] staging: dgrp: dgrp_tty.c: Audit the return values of
 get/put_user()
Message-ID: <20121121221139.GA7682@kroah.com>
References: <1353322531-10092-1-git-send-email-gmate.amit@gmail.com>
 <20121119111553.GC6186@mwanda>
 <20121119130829.GB3275@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119130829.GB3275@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 06:38:29PM +0530, Kumar amit mehta wrote:
> On Mon, Nov 19, 2012 at 02:15:54PM +0300, Dan Carpenter wrote:
> > On Mon, Nov 19, 2012 at 04:25:31PM +0530, Kumar Amit Mehta wrote:
> > > -- fix for missing audits for return values of get_user() and put_user().
> > > -- Remove the TIOCSSOFTCAR ioctl handling from dgrp driver.
> > 
> > These should be done in separate commits.
> > 
> > Are the calls to access_ok() still needed if we check get_user() and
> > put_user()?
> >
> You are right, access_ok() would become redundant if we check get/put_user().
> Also, After sending one patch for removing TIOCSSOFTCAR ioctl handler from dgrp
> driver, I realized that I should be sending two patches as patch series. Please
> correct me if I'm wrong.

Yes, please resend, as I can't apply this one, and the other patch you
sent me as they conflict.  So please resend them both in proper format.

thanks,

greg k-h
