Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab0CPVZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:25:13 -0400
Received: from mga05.intel.com ([192.55.52.89]:11278 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751989Ab0CPVZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,652,1262592000"; 
   d="scan'208";a="549608244"
Date: Tue, 16 Mar 2010 14:24:45 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
Message-ID: <20100316212445.GA15729@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316204845.GJ8278@ldl.fc.hp.com>
 <20100309184723.GA31374@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:47:23AM -0800, Greg KH wrote:
> On Tue, Mar 09, 2010 at 11:32:27AM -0700, Alex Chiang wrote:
> > * Greg KH <greg@kroah.com>:
> > > On Tue, Mar 09, 2010 at 10:52:43AM -0700, Alex Chiang wrote:
> > > 
> > > >       USB: xhci: move all debug code under CONFIG_XHCI_HCD_DEBUGGING
> > > 
> > > Does this conflict with Sarah's other debugging patch she just sent out?
> > 
> > I'm assuming you're talking about this patch:
> > 
> > 	http://thread.gmane.org/gmane.linux.usb.general/28681
> 
> Yes.
> 
> > Yes, we'll definitely have conflicts. If you agree that we should
> > move the debug code under the Kconfig option, then the best
> > course of action would be for Sarah to rebase her work on top of
> > my patches (since they're intrusive).
> 
> As Sarah is the maintainer of the file, I'll leave that decision up to
> her :)
> 
> And keeping a config option for debugging isn't a good idea.  The rest
> of the kernel has switched to using dynamic debugging, so that distros
> and others can easily get information without requiring a kernel rebuild
> (which we can't expect users to always be able to do.)  So I would not
> recommend this change.
> 
> thanks,
> 
> greg k-h

On Tue, Mar 16, 2010 at 02:48:45PM -0600, Alex Chiang wrote:
> Naming consistency with other USB HCDs.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> Refreshed against 2.6.34-rc1 and compile tested.
> 
> I didn't refresh the debug one; waiting to hear back from Sarah
> to see if it's worth doing or not.

Ok, I didn't see Greg's email about dynamic debugging.  I guess you
shouldn't refresh the second patch.  I'm not sure how I would go about
converting the xHCI driver to dynamic debugging, as I haven't looked
into it.  Is there any documentation/simple examples?

Greg, does the less-verbose patch with log levels still make sense if
the driver got converted over to dynamic debugging?

Sarah Sharp
