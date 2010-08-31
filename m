Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0HaQdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:33:25 -0400
Received: from kroah.org ([198.145.64.141]:36842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0HaQdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:33:24 -0400
Date: Tue, 31 Aug 2010 09:32:20 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35
Message-ID: <20100831163220.GA6440@kroah.com>
References: <1281140943.4035.7.camel@odc-laptop>
 <20100831002756.GA8304@kroah.com>
 <DA59ECC057A74C138BDCDA5E93771F77@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DA59ECC057A74C138BDCDA5E93771F77@stanford.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 09:17:18AM -0700, David Cross wrote:
> 
> > I get a build error when I try to build this driver:
> >
> drivers/staging/westbridge/astoria/block/../include/linux/westbridge/c>
> yasmisc.h:521:2: error: expected declaration specifiers or '...' before  >
> 'cy_as_hal_device_tag'
> 
> > It looks like the #include mess isn't working quite properly.
> 
> > Also note that this driver is building on an x86-64 platform, which is
> > something that you probably don't want :)
> 
> > So, for now, I'll just mark the driver as CONFIG_BROKEN and can you send
> > me some Kconfig patches against the next linux-next release which should
> > have this driver in it, so that it will build properly?
> 
> Sure, I can do that. I have since changed the Kconfig structure a bit. It
> actually will build properly with the correct .config as it is though. I can
> send you the .config if you would like.

It's up to the Kconfig rules to ensure that there can never be a
"non-correct" .config file, so that needs to be fixed so that the build
will never be broken no matter what type of options are selected.

Care to send a patch for that?

thanks,

greg k-h
