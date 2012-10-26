Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab2JZX4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 19:56:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:47602 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934214Ab2JZX4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 19:56:51 -0400
Date: Fri, 26 Oct 2012 16:56:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] firmware: Add /proc/firmware_path entry to list
 the firmware paths
Message-ID: <20121026235649.GB13263@kroah.com>
References: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1350996776-17864-3-git-send-email-dp@opensource.wolfsonmicro.com>
 <20121025184833.GA22114@kroah.com>
 <20121026100731.GA10468@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026100731.GA10468@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:07:31AM +0100, Dimitris Papastamos wrote:
> On Thu, Oct 25, 2012 at 11:48:33AM -0700, Greg Kroah-Hartman wrote:
> > On Tue, Oct 23, 2012 at 01:52:55PM +0100, Dimitris Papastamos wrote:
> > > This patch provides the aforementioned procfs file that lists
> > > the default firmware paths that are used during firmware lookup.
> > > 
> > > The file contains a white space separated list of paths.
> > 
> > Paths can have whitespaces :(
> > 
> > How about using the "universal" path seperator of ':' that shells are
> > used to using?  Yeah, it gets messy if you have a ':' in a path, but
> > from what I can tell, only the openSUSE build system does looney things
> > like that.
> 
> Sure I can do that, however, could you comment on Ming's comments?  Is
> this patchset something we find useful at the moment as regards listing
> and/or updating the firmware path list.

I really don't remember anymore, sorry.  That was a few hunderd or so
patches ago that I've reviewed...

greg k-h
