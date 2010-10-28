Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733Ab0J1Roj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:44:39 -0400
Received: from kroah.org ([198.145.64.141]:48846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760223Ab0J1Rog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:44:36 -0400
Date: Thu, 28 Oct 2010 10:44:32 -0700
From: Greg KH <greg@kroah.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: How do I add yaffs file system to mainline?
Message-ID: <20101028174432.GA2001@kroah.com>
References: <201010290455.02390.manningc2@actrix.gen.nz>
 <20101028102641.d936aec8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028102641.d936aec8.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:26:41AM -0700, Randy Dunlap wrote:
> On Fri, 29 Oct 2010 04:55:02 +1300 Charles Manning wrote:
> 
> > YAFFS has been used for many years as a third-party patch-in.
> > 
> > I have recently been through the exercise of changing all the symbols to be 
> > more kernel friendly with the intention of mainlining into the linux tree.
> > 
> > The code is in git at http://github.com/cdhmanning/linux-yaffs-integration/
> 
> It's difficult to review & comment on a git tree.
> We prefer patches via email for review.
> 
> > Thanks to CELF and Google for sponsoring the effort so far.
> > 
> > What still needs to be done to mainline this?
> > Who do I need to approach?
> 
> Either ask Stephen Rothwell to add the git tree to the linux-next daily tree
> or ask Greg KH to add it to the drivers/staging/ area.

I'd be glad to add the code to the staging tree, but to do so, do you
have a list of things that are left to do in order to get it properly
merged to the "real" portion of the kernel?

And if so, what is preventing you from doing those tasks right now to
get the code into the .38 kernel merge?

thanks,

greg k-h
