Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1ASWyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:54:40 -0500
Received: from kroah.org ([198.145.64.141]:36235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab1ASWyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:54:38 -0500
Date: Wed, 19 Jan 2011 14:41:05 -0800
From: Greg KH <greg@kroah.com>
To: Earl Chew <echew@ixiacom.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: UIO  null parent for __uio_register_device and
 uio_device_name()
Message-ID: <20110119224105.GA23401@kroah.com>
References: <4D366104.1000400@ixiacom.com>
 <20110119145619.GA17399@local>
 <4D370654.7020400@ixiacom.com>
 <20110119163005.GA12979@kroah.com>
 <4D371A35.5000009@ixiacom.com>
 <20110119205243.GC17399@local>
 <4D376079.8020108@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D376079.8020108@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:06:49PM -0800, Earl Chew wrote:
> Hans Koch wrote:
> > There's a small library with helper functions. Among other things, they
> > allow searching the UIO device node by name (the name you gave your device
> > in uio_info->name). The library is here:
> > 
> > git://git.linutronix.de/projects/libUIO.git
> > 
> > or with gitweb:
> > 
> > http://git.linutronix.de/gitweb.cgi?p=projects/libUIO.git;a=summary
> 
> Hans, Greg,
> 
> I appreciate the chance to discuss this change with you. I do understand your
> point of view, and I can see how libUIO navigates sysfs from userspace
> to figure out what's there.
> 
> Unfortunately I am not in a position to mandate the inclusion of sysfs in our
> deployment, and Linux UIO has a dependency on sysfs to be usable.

I still fail to see why sysfs has been deemed "unacceptable".

What is wrong with it that is keeping you from using it?  Technical
details please, otherwise there is no way for me to ever be able to fix
them.

thanks,

greg k-h
