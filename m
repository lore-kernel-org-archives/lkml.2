Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0FCQxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:53:38 -0400
Received: from kroah.org ([198.145.64.141]:42660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab0FCQxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:53:35 -0400
Date: Thu, 3 Jun 2010 09:50:55 -0700
From: Greg KH <greg@kroah.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 1/5] BKL: autoconvert trivial users to private mutex
Message-ID: <20100603165055.GA7639@kroah.com>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
 <1275523999-27462-2-git-send-email-arnd@arndb.de>
 <20100603003512.GC5164@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603003512.GC5164@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:35:13AM +0200, Frederic Weisbecker wrote:
> On Thu, Jun 03, 2010 at 02:13:15AM +0200, Arnd Bergmann wrote:
> >  drivers/staging/crystalhd/crystalhd_lnx.c  |    9 +++--
> >  drivers/staging/dt3155/dt3155_drv.c        |    7 ++--
> >  drivers/staging/vme/devices/vme_user.c     |    7 ++--
> >  drivers/usb/gadget/printer.c               |    7 ++--
> >  drivers/usb/misc/iowarrior.c               |   15 +++++----
> >  drivers/usb/misc/rio500.c                  |   15 +++++----
> >  drivers/usb/misc/usblcd.c                  |   16 +++++-----
> 
> 
> 
> Nice.
> 
> If you could split the patchset, even by grouping some drivers
> from the same family in the same patches, I can host the orphans.

I agree, I'd gladly take the drivers/usb/* and drivers/staging/* patches
in my trees.

thanks,

greg k-h
