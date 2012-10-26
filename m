Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2JZKHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:07:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43750 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab2JZKHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:07:35 -0400
Date: Fri, 26 Oct 2012 11:07:31 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] firmware: Add /proc/firmware_path entry to list
	the firmware paths
Message-ID: <20121026100731.GA10468@opensource.wolfsonmicro.com>
References: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com> <1350996776-17864-3-git-send-email-dp@opensource.wolfsonmicro.com> <20121025184833.GA22114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025184833.GA22114@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:48:33AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Oct 23, 2012 at 01:52:55PM +0100, Dimitris Papastamos wrote:
> > This patch provides the aforementioned procfs file that lists
> > the default firmware paths that are used during firmware lookup.
> > 
> > The file contains a white space separated list of paths.
> 
> Paths can have whitespaces :(
> 
> How about using the "universal" path seperator of ':' that shells are
> used to using?  Yeah, it gets messy if you have a ':' in a path, but
> from what I can tell, only the openSUSE build system does looney things
> like that.

Sure I can do that, however, could you comment on Ming's comments?  Is
this patchset something we find useful at the moment as regards listing
and/or updating the firmware path list.

> > There will be another patch on top of this that adds the functionality
> > to modify the paths at runtime.
> 
> Did I miss that patch somewhere?

That patch is here:
	http://opensource.wolfsonmicro.com/~dp/patches/firmware/0004-firmware-Add-write-support-to-proc-fw_path.patch

However I've not rebased that patch on top of linux-next and I did not
send it for review as it seems that it may be a more sensible solution
to pass this as a kernel parameter.

Let me know what you think and I'll squeeze some time this weekend
to look at this.

Thanks,
Dimitris
