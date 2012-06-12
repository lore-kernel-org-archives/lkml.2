Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2FLBmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:42:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48137 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2FLBmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:42:44 -0400
Date: Mon, 11 Jun 2012 18:42:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Subject: Re: [PATCH] staging: comedi: cleanup alloc_subdevices
Message-ID: <20120612014239.GA32087@kroah.com>
References: <201206071508.15674.hartleys@visionengravers.com>
 <20120611235657.GA26721@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
 <20120612004421.GA30997@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4B9@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698DBC4B9@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 07:49:46PM -0500, H Hartley Sweeten wrote:
> On Monday, June 11, 2012 5:44 PM, Greg KH wrote:
> > On Mon, Jun 11, 2012 at 07:07:41PM -0500, H Hartley Sweeten wrote:
> >> 2, 3, and 4 probably go together. They all deal with the 'num_subdevices'
> >> 
> >> 1 can be a separate patch as long as I don't do the rename.
> >> 
> >> 5, 6, and 7 could all go together with the final rename of the function.
> >> 
> >> Does that sound ok?
> >
> > No, why not just break it up into 7 different patches?  You are doing
> > different things, which would you rather review for correctness, 7
> > simple, tiny patches, or some that do multiple things at the same time
> > that are bigger?
> 
> Ok. I just posted the first one. It's still pretty big since it hits every
> comedi driver file.
> 
> Please ignore the first post. I fat-fingered the prototype in the header.
> v2 is correct.
> 
> Also, I have never done local commits to my Linux-next tree so I'm not
> sure how to proceed with the incremental patches. If it's ok with you
> I'll just wait for each patch to go into staging.

Create a brach from the one you are working on:
	git branch -b my_branch
make a change and commit it
commit another one
and so on.
then create the patches:
	git format-patch original_branch_name..my_branch
and use git send-email to send them off in order.

Otherwise we are going to take 7 weeks when I apply one of your patches
a week :)

thanks,

greg k-h
