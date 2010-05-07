Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0EGRJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:09:46 -0400
Received: from kroah.org ([198.145.64.141]:42651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab0EGRJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:09:44 -0400
Date: Fri, 7 May 2010 09:56:07 -0700
From: Greg KH <greg@kroah.com>
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] nfs kernel server causes: kernel BUG at
 include/linux/module.h:386!
Message-ID: <20100507165606.GA795@kroah.com>
References: <4BE257EF.9050904@gmail.com>
 <20100506060326.GA20846@kroah.com>
 <4BE3BCDF.4080604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE3BCDF.4080604@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 10:10:23AM +0300, roma1390 wrote:
> Greg KH wrote:
> > On Thu, May 06, 2010 at 08:47:27AM +0300, roma1390 wrote:
> >> Hello,
> >>
> >> after some nfs server start/stop i hit kernel bug on 2.6.26.
> There is hope[1] that this bug is fixed[2], and fix is merged[3]
> into 2.6.29. But there is missing bugfix for older stable kernels.
> >
> > 2.6.26 is not supported by the community anymore.
> 
> Sadly, the debian 5.0 (current stable) chose 2.6.26 as distribution
> kernel. Of course they do kernel as part of distribution support by
> them self.
> 
> > Is this a problem on the latest 2.6.27-stable kernel release?  If so,
> > which specific patches in Linus's tree do you think resolves this?  Is
> > it just the 22945e4a1c7454c97f5d8aee1ef526 commit that is needed to be
> > added there?
> 
> Currently there isn't any free resources to do 2.6.27-stable
> testing. Switching from distribution kernel to custom one adds much
> more work for system admin, so this options is the last one none
> other will work.
> 
> If there is any demand to test 22945e4a1c7454c97f5d8aee1ef526, there
> can be such test done. But this issue was found only once, and on
> first hour after nfs server configuration was started.

If you can't test it, if I add that commit id to .27, I don't see how
that would help you out at all, right?

Can you poke the debian developers about this?

thanks,

greg k-h
