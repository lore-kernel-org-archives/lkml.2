Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2FLSpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:45:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57795 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2FLSpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:45:53 -0400
Date: Tue, 12 Jun 2012 11:45:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: cleanup alloc_subdevices
Message-ID: <20120612184548.GA19550@kroah.com>
References: <201206071508.15674.hartleys@visionengravers.com>
 <20120611235657.GA26721@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
 <20120612004421.GA30997@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4B9@AUSP01VMBX24.collaborationhost.net>
 <20120612014239.GA32087@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC6D7@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698DBC6D7@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 01:31:38PM -0500, H Hartley Sweeten wrote:
> On Monday, June 11, 2012 6:43 PM, Greg KH wrote:
> > On Mon, Jun 11, 2012 at 07:49:46PM -0500, H Hartley Sweeten wrote:
> >> Also, I have never done local commits to my Linux-next tree so I'm not
> >> sure how to proceed with the incremental patches. If it's ok with you
> >> I'll just wait for each patch to go into staging.
> >
> > Create a brach from the one you are working on:
> > 	git branch -b my_branch
> > make a change and commit it
> > commit another one
> > and so on.
> > then create the patches:
> > 	git format-patch original_branch_name..my_branch
> > and use git send-email to send them off in order.
> >
> > Otherwise we are going to take 7 weeks when I apply one of your patches
> > a week :)
> 
> Greg,
> 
> I did as you described above and have the 7 patches ready but I just
> noticed you have already applied the first one.
> 
> Should I post the entire series and note that the first one is already
> applied?

Yup, that will be fine, I can easily delete that one from my inbox :)

thanks,

greg k-h
