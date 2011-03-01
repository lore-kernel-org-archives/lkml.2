Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab1CAOWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:22:42 -0500
Received: from kroah.org ([198.145.64.141]:58131 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1CAOWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:22:39 -0500
Date: Tue, 1 Mar 2011 09:15:27 -0500
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <alan@linux.jf.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: gma500: Rip out the memory manager
Message-ID: <20110301141527.GA12881@kroah.com>
References: <20110224162440.27093.80825.stgit@localhost.localdomain>
 <20110224162457.27093.32399.stgit@localhost.localdomain>
 <20110301020302.GA11353@kroah.com>
 <20110301122437.4477fa65@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301122437.4477fa65@bob.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 12:24:37PM +0000, Alan Cox wrote:
> On Mon, 28 Feb 2011 18:03:02 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Feb 24, 2011 at 04:25:09PM +0000, Alan Cox wrote:
> > > At this point we simply stuff the display at the start of the
> > > stolen memory area that the BIOS gave us. No user framebuffers no
> > > multiple framebuffers.
> > > 
> > > However from here we have a better chance of seeing what is going
> > > on and writing an actual gem manager for the driver.
> > > 
> > > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > 
> > This doesn't apply.
> > 
> > The 1/2 patch had some fuzz in the Makefile, which I fixed up by hand,
> > but it makes me think that you are diffing this against some different
> > tree.
> 
> I've investigated this. The cause seems to be a patch
> 
> commit 5352161fc449d7a7573b2e13bd02162aae7aeb69
> 
> applied by yourself which cleaned up all sorts of random whitespace
> noise and broke further patch application. Given that this is staging
> and random whitespace is less important than actually fixing the code I
> think the fix is to revert that commit and then apply mine.

Well, I did copy you on that patch, and let you know I made it, so this
type of thing wouldn't happen.  I'll go fix it by just stripping out the
trailing whitespace from your patch :)

This doesn't seem to explain the Makefile difference in the 1/2 patch
though...

thanks,

greg k-h
