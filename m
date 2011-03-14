Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab1CNVQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:16:41 -0400
Received: from kroah.org ([198.145.64.141]:35896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1CNVQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:16:40 -0400
Date: Mon, 14 Mar 2011 14:13:35 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: andy.green@linaro.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
Message-ID: <20110314211335.GA2351@kroah.com>
References: <20110314205432.GA1856@kroah.com>
 <Pine.LNX.4.44L0.1103141659080.4194-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1103141659080.4194-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 05:03:17PM -0400, Alan Stern wrote:
> On Mon, 14 Mar 2011, Greg KH wrote:
> 
> > No, it has been determined a long time ago that network naming things
> > like this are to be done in userspace.  It's an argument that has come
> > and gone many years ago, sorry.  See all of the wonderful, and simple,
> > tools we have today in userspace to handle this type of thing.  Distros
> > can use them how ever they see fit, and even better, users can configure
> > them!  That means they don't have to rebuild their kernels, which is a
> > bit unreasonable, don't you think?
> 
> ...
> 
> > Perhaps we should just always name these things 'eth%d'?  Oh wait, as it
> > really is a USB device, they are supposed to be called 'usb%d' as
> > determined (again) a long time ago.
> > 
> > If a distro/board manufacturer wants to hide the fact that this really
> > is a usb device by renaming it to eth0, then again, it can.  But don't
> > force the kernel to have that policy in it.
> 
> This argument does sound contradictory.  If network interface naming 
> should be left entirely up to userspace, then why doesn't the kernel 
> always generate names of the form "eth%d"?  Why not rip all that stuff 
> about "usb%d" or "wlan%d" out of the driver entirely?
> 
> (Apart from the fact that this would be a user-visible change in kernel 
> policy and would break a large number of systems...)

I think that is the only reason it is sticking around.

thanks,

greg k-h
