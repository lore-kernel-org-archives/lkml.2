Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab0J1SVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:21:35 -0400
Received: from kroah.org ([198.145.64.141]:46292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761117Ab0J1SV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:21:29 -0400
Date: Thu, 28 Oct 2010 11:08:45 -0700
From: Greg KH <greg@kroah.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: How do I add yaffs file system to mainline?
Message-ID: <20101028180845.GA2573@kroah.com>
References: <201010290455.02390.manningc2@actrix.gen.nz>
 <20101028102641.d936aec8.randy.dunlap@oracle.com>
 <20101028174432.GA2001@kroah.com>
 <201010290655.39490.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010290655.39490.manningc2@actrix.gen.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 06:55:39AM +1300, Charles Manning wrote:
> On Friday 29 October 2010 06:44:32 Greg KH wrote:
> > On Thu, Oct 28, 2010 at 10:26:41AM -0700, Randy Dunlap wrote:
> > > On Fri, 29 Oct 2010 04:55:02 +1300 Charles Manning wrote:
> > > > YAFFS has been used for many years as a third-party patch-in.
> > > >
> > > > I have recently been through the exercise of changing all the symbols
> > > > to be more kernel friendly with the intention of mainlining into the
> > > > linux tree.
> > > >
> > > > The code is in git at
> > > > http://github.com/cdhmanning/linux-yaffs-integration/
> > >
> > > It's difficult to review & comment on a git tree.
> > > We prefer patches via email for review.
> > >
> > > > Thanks to CELF and Google for sponsoring the effort so far.
> > > >
> > > > What still needs to be done to mainline this?
> > > > Who do I need to approach?
> > >
> > > Either ask Stephen Rothwell to add the git tree to the linux-next daily
> > > tree or ask Greg KH to add it to the drivers/staging/ area.
> >
> > I'd be glad to add the code to the staging tree, but to do so, do you
> > have a list of things that are left to do in order to get it properly
> > merged to the "real" portion of the kernel?
> 
> We're getting into a Catch-22 discussion here... Until I fully understand what 
> is needed, I can't really say what needs to be done :-).
> 
> At this stage the code works, is integrated into, and compiles cleanly against 
> Linus' 2.6 git. My git is based on Linus' 2.6 as of yesterday.
> 
> I have done symbol cleaning changing the old yaffs names of the form 
> yaffs_ScanBackwards() to yaffs_scan_backward() etc.
> 
> What I really need is someone to look at what's there and tell me if there are 
> still style issues etc that need changing.
> 
> I know there is a style guide etc, but when we're talking about processing 15k 
> loc then some of those rules might be slightly bendable.

Not really.

Have you run it through sparse and scripts/checkpatch.pl?  If not,
please do so and resolve all of the issues that they bring up.

Then break up the filesystem into reviewable patches and send them to
the linux-fsdevel list for review.

Again, read Documentation/SubmittingPatches for the details on how to
properly do this, it is described in very good detail :)

> > And if so, what is preventing you from doing those tasks right now to
> > get the code into the .38 kernel merge?
> 
> My biggest problem is not fully understanding the process.

The process is very well documented, have you read the documentation?
If so, what part is lacking?

thanks,

greg k-h
