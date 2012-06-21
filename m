Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2FUA2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:28:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49413 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2FUA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:28:34 -0400
Date: Wed, 20 Jun 2012 17:28:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: skel: use module_comedi_{pci_,}driver()
Message-ID: <20120621002830.GA3255@kroah.com>
References: <201206201556.51336.hartleys@visionengravers.com>
 <20120620231230.GA28411@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698E77071@AUSP01VMBX24.collaborationhost.net>
 <20120620232331.GA25587@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698E7708B@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698E7708B@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 07:21:04PM -0500, H Hartley Sweeten wrote:
> On Wednesday, June 20, 2012 4:24 PM, Greg KH wrote:
> > On Wed, Jun 20, 2012 at 06:16:52PM -0500, H Hartley Sweeten wrote:
> >> Hmm. It was based on next-20120620 and created with git format-patch.
> >> 
> >> Do you have any other patches to that file in your staging tree that
> >> have not reached the next tree yet?
> >
> > Possibly, depending on when -next was created, I did just apply a bunch
> > of other patches a few hours ago.
> >
> >> Regardless, I have some other cleanup patches for that file. I'll
> >> put them together as a series and repost it later.
> >
> > That would be great, thanks.
> 
> Not a problem.
> 
> Question.
> 
> Is there a way to do a 'git commit' with the diff generated using the
> "patience diff" algorithm?

I have no idea what that is.

> I have a patch that is really ugly when I do the git commit but looks
> ok if I do a 'git diff --patience'.

It's ok, send it on, I'll figure it out :)

thanks,

greg k-h
