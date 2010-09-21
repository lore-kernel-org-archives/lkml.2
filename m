Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0IUNmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:42:12 -0400
Received: from kroah.org ([198.145.64.141]:55295 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab0IUNmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:42:11 -0400
Date: Tue, 21 Sep 2010 06:40:27 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: liguozhu@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: Problem with debugfs
Message-ID: <20100921134027.GA3139@kroah.com>
References: <20100921022112.GA10336@localhost>
 <20100921034314.GA14062@kroah.com>
 <20100920213825.72ac1a92.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920213825.72ac1a92.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 09:38:25PM -0700, Randy Dunlap wrote:
> On Mon, 20 Sep 2010 20:43:14 -0700 Greg KH wrote:
> 
> > On Tue, Sep 21, 2010 at 10:21:12AM +0800, liguozhu@huawei.com wrote:
> > > Hi, there,
> > > 
> > > I do not know who is the maintainer for debugfs now.
> > 
> > Did it change?  It's always been me.  I guess I never created a
> > MAINTAINERS entry, is it really needed?
> 
> 
> We shouldn't assume that everyone uses git and can then use
> ./scripts/get_maintainer.pl.

Good point, I've queued up the following patch to my trees.

thanks,

greg k-h

----------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: debugfs: mark me as the maintainer

Add DEBUGFS information to my MAINTAINERS entry as some people have
asked about this recently.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2033,14 +2033,16 @@ F:	drivers/block/drbd/
 F:	lib/lru_cache.c
 F:	Documentation/blockdev/drbd/
 
-DRIVER CORE, KOBJECTS, AND SYSFS
+DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS
 M:	Greg Kroah-Hartman <gregkh@suse.de>
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
 F:	Documentation/kobject.txt
 F:	drivers/base/
 F:	fs/sysfs/
+F:	fs/debugfs/
 F:	include/linux/kobj*
+F:	include/linux/debugfs.h
 F:	lib/kobj*
 
 DRM DRIVERS
