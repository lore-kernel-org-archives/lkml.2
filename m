Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab0J1Rtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:49:51 -0400
Received: from kroah.org ([198.145.64.141]:59726 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab0J1Rtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:49:40 -0400
Date: Thu, 28 Oct 2010 10:49:32 -0700
From: Greg KH <greg@kroah.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: How do I add yaffs file system to mainline?
Message-ID: <20101028174932.GB2205@kroah.com>
References: <201010290455.02390.manningc2@actrix.gen.nz>
 <20101028102641.d936aec8.randy.dunlap@oracle.com>
 <201010290641.13820.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010290641.13820.manningc2@actrix.gen.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 06:41:13AM +1300, Charles Manning wrote:
> On Friday 29 October 2010 06:26:41 Randy Dunlap wrote:
> > On Fri, 29 Oct 2010 04:55:02 +1300 Charles Manning wrote:
> > > YAFFS has been used for many years as a third-party patch-in.
> > >
> > > I have recently been through the exercise of changing all the symbols to
> > > be more kernel friendly with the intention of mainlining into the linux
> > > tree.
> > >
> > > The code is in git at
> > > http://github.com/cdhmanning/linux-yaffs-integration/
> >
> > It's difficult to review & comment on a git tree.
> > We prefer patches via email for review.
> >
> > > Thanks to CELF and Google for sponsoring the effort so far.
> > >
> > > What still needs to be done to mainline this?
> > > Who do I need to approach?
> >
> > Either ask Stephen Rothwell to add the git tree to the linux-next daily
> > tree or ask Greg KH to add it to the drivers/staging/ area.
> 
> Hi Randy
> 
> Thanks for the response. 
> 
> At this stage I'm hoping for some high level feedback about code layout etc. 
> and don't expect an immediate approval. I expect to do some further code 
> cleansing before getting a green light.
> 
> We're talking around 15k lines of code. Is a huge patch set the right way?
>  I thought it would be more polite to invite people to look at git, rather 
> than filling everyone's inboxes. 

Have you read Documentation/SubmittingPatches and
Documentation/development_process/ which explains how to break up your
code and send it out for review properly?

No one is going to look at a random git tree with 15k lines of code for
a review, sorry.  Would you?

thanks,

greg k-h
