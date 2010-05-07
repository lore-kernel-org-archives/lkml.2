Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0EGRJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:09:47 -0400
Received: from kroah.org ([198.145.64.141]:42652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab0EGRJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:09:45 -0400
Date: Fri, 7 May 2010 09:56:53 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] drivers: staging: dream: fix smd in makefile
Message-ID: <20100507165653.GB795@kroah.com>
References: <1273189739-1710-1-git-send-email-dwalker@codeaurora.org>
 <20100506235433.GA4477@kroah.com>
 <1273190401.20494.44.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273190401.20494.44.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 05:00:01PM -0700, Daniel Walker wrote:
> On Thu, 2010-05-06 at 16:54 -0700, Greg KH wrote:
> > On Thu, May 06, 2010 at 04:48:59PM -0700, Daniel Walker wrote:
> > > Not sure about this one.. Cause if you apply this then some SMD files
> > > don't compile anymore. There's some missing config options related to
> > > AMSS.
> > > 
> > > NOT-Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> > 
> > Heh, I'm not going to apply this then :)
> > 
> > > CC: Greg KH <greg@kroah.com>
> > > Cc: Pavel Machek <pavel@ucw.cz>
> > > ---
> > >  drivers/staging/dream/Makefile |    3 ++-
> > 
> > With the recent progression of your arch tree, and the
> > wakelock/suspend-blocker stuff, what's the need for these files to still
> > be in the staging directory at all?  Can't it be deleted and it go
> > through your tree?
> 
> Yeah, all the smd stuff can .. The rest of it should stay for now I
> think. I'm not ready to take on those other specific drivers, like the
> camera etc..
> 
> Should I just send a patch to drop the whole SMD directory then?

Yes, I think so.  Pavel, any objections?

thanks,

greg k-h
