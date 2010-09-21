Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0IUWv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:51:27 -0400
Received: from kroah.org ([198.145.64.141]:40997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab0IUWv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:51:26 -0400
Date: Tue, 21 Sep 2010 15:51:15 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] FW_LOADER: fix kconfig dependency warning on HOTPLUG
Message-ID: <20100921225115.GA16237@kroah.com>
References: <20100918132308.074b6c01.randy.dunlap@oracle.com>
 <20100921222548.GA21202@kroah.com>
 <4C99359D.9020700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C99359D.9020700@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 03:45:49PM -0700, Randy Dunlap wrote:
> On 09/21/10 15:25, Greg KH wrote:
> > On Sat, Sep 18, 2010 at 01:23:08PM -0700, Randy Dunlap wrote:
> >>
> >> BTW, drivers/base/firmware_class.c should #include <linux/kobject.h>.
> > 
> > Why, it looks like it builds properly now, right?
> 
> Yes, it builds because (apparently) some other header file is causing
> <linux/kobject.h> to be sucked in.  That's not how we prefer to have header
> files used.
> 
> See Documentation/SubmitChecklist, item #1 (from Stephen Rothwell):
> 
> 1: If you use a facility then #include the file that defines/declares
>    that facility.  Don't depend on other header files pulling in ones
>    that you use.

Fair enough, care to send a patch?  :)

thanks,

greg k-h
