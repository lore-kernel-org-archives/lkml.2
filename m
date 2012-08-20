Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2HTPBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:01:39 -0400
Received: from fieldses.org ([174.143.236.118]:42388 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab2HTPBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:01:37 -0400
Date: Mon, 20 Aug 2012 11:01:31 -0400
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Holger Hoffstaette <holger.hoffstaette@googlemail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ 00/46] 3.5.3-stable review
Message-ID: <20120820150130.GD1411@fieldses.org>
References: <20120820035832.274275502@linuxfoundation.org>
 <pan.2012.08.20.08.26.25.90194@googlemail.com>
 <20120820144613.GA27130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820144613.GA27130@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 07:46:13AM -0700, Greg KH wrote:
> On Mon, Aug 20, 2012 at 10:26:25AM +0200, Holger Hoffstaette wrote:
> > (CC: J. Bruce Fields)
> > 
> > Greg,
> > 
> > it looks like a fix for a regression in NFS is not mentioned in this
> > patch even though it was supposedly sent to -stable:
> > http://lkml.indiana.edu/hypermail/linux/kernel/1208.2/00594.html
> > 
> > I tried to locate the patch in git but could not find it anywhere. As far
> > as I can tell the fix works; in my case I noticed repeatable hangs when
> > trying to "move files to the trash" in XFCE and these hangs are now gone.
> > Have not noticed any negative side effects either.
> 
> Is the patch you reference above in Linus's tree?  That is a requirement
> before I can accept it into a stable release (please read
> Documentation/stable_kernel_rules.txt for the details.)

Right, Holger, the way this works is I queue these things up for Linus
but don't necessarily submit them right away.  Bug me (not Greg) if I
haven't done that in a couple days.

--b.
