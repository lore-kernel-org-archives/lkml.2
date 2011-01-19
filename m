Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1ASR0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:26:11 -0500
Received: from kroah.org ([198.145.64.141]:45680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1ASR0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:26:10 -0500
Date: Wed, 19 Jan 2011 09:24:14 -0800
From: Greg KH <greg@kroah.com>
To: Earl Chew <echew@ixiacom.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: UIO  null parent for __uio_register_device and
 uio_device_name()
Message-ID: <20110119172414.GA18010@kroah.com>
References: <4D366104.1000400@ixiacom.com>
 <20110119145619.GA17399@local>
 <4D370654.7020400@ixiacom.com>
 <20110119163005.GA12979@kroah.com>
 <4D371A35.5000009@ixiacom.com>
 <4D371B28.8020501@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D371B28.8020501@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:11:04AM -0800, Earl Chew wrote:
> Greg,
> 
> I wrote:
> > I think you're telling me you won't accept either of:
> > 
> > a. uio_device_name()
> > b. uio_device_chrdev()
> [ snip ]
> > With no sysfs, I cannot think of a way to get hold of the minor number allocated
> > to this instance of the Linux UIO device, and without that I can't open() the
> > device driver.
> 
> Would you consider :
> 
> 	extern int uio_device_minor(struct uio_info *info);
> 
> ?
> 
> That would allow me to reconstitute the coordinates of the Linux UIO device
> instance from a combination of /proc/devices and a uio_device_minor() query.

Again, no, this is already present in userspace, and no kernel code
should ever need it.

sorry.

greg k-h
