Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0IBBil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:38:41 -0400
Received: from kroah.org ([198.145.64.141]:45934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab0IBBik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:38:40 -0400
Date: Wed, 1 Sep 2010 18:37:19 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35, Kconfig fixes
Message-ID: <20100902013719.GC4744@kroah.com>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu>
 <1283386101.17399.10.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283386101.17399.10.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 05:08:21PM -0700, David Cross wrote:
> 
> > From: Greg KH [mailto:greg@kroah.com] 
> > Sent: Tuesday, August 31, 2010 9:32 AM
> > To: David Cross
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35
> > 
> > On Tue, Aug 31, 2010 at 09:17:18AM -0700, David Cross wrote:
> > > 
> > > > I get a build error when I try to build this driver:
> > > >
> > > drivers/staging/westbridge/astoria/block/../include/linux/westbridge/c>
> > > yasmisc.h:521:2: error: expected declaration specifiers or '...' before  >
> > > 'cy_as_hal_device_tag'
> > > 
> > > > It looks like the #include mess isn't working quite properly.
> > > 
> > > > Also note that this driver is building on an x86-64 platform, which is
> > > > something that you probably don't want :)
> > > 
> > > > So, for now, I'll just mark the driver as CONFIG_BROKEN and can you send
> > > > me some Kconfig patches against the next linux-next release which should
> > > > have this driver in it, so that it will build properly?
> > > 
> > > Sure, I can do that. I have since changed the Kconfig structure a bit. It
> > > actually will build properly with the correct .config as it is though. I
> > can
> > > send you the .config if you would like.
> > 
> > It's up to the Kconfig rules to ensure that there can never be a
> > "non-correct" .config file, so that needs to be fixed so that the build
> > will never be broken no matter what type of options are selected.
> > 
> > Care to send a patch for that?
> 
> This patch actually contains quite a few fixes, but it addresses the
> Kconfig issue as well. The linux-next tree does not seem to have a
> config for the zoom2, and trying to build it for that board seems to
> make the compilation break. As such, the only thing that I tested was
> compilation using the two different HALs (one of which is added in this
> patch). Please let me know if there are problems or questions with this.
> Thanks,
> David

Hm, I need a single-patch-per-change, as described in the
Documentation/SubmittingPatches file.  So, could you break this up into
the logical changes, so that I can apply them all?  That makes it easier
for everyone involved (reviewing, bisecting, etc.) and it's what is
needed for the rest of the kernel as well.

thanks,

greg k-h
