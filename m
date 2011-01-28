Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1A1PVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:21:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:47774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1A1PVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:21:19 -0500
Date: Fri, 28 Jan 2011 07:20:27 -0800
From: Greg KH <gregkh@suse.de>
To: Amit Shah <amit.shah@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Message-ID: <20110128152027.GA5213@suse.de>
References: <20110120174910.GA30124@kroah.com>
 <1295546625-30681-1-git-send-email-gregkh@suse.de>
 <20110127182916.GA4688@amit-x200.redhat.com>
 <201101272253.29223.arnd@arndb.de>
 <20110128025725.GA2822@amit-x200.redhat.com>
 <20110128042125.GA1844@suse.de>
 <20110128055904.GA9218@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128055904.GA9218@amit-x200.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 11:29:04AM +0530, Amit Shah wrote:
> On (Thu) Jan 27 2011 [20:21:25], Greg KH wrote:
> > > > Sorry about this, the idea to move this file was mine and my original
> > > > patch did this as well. I remembered the code from when it was a simple
> > > > console driver based on hvc and never noticed that it had evolved into
> > > > a generic host/guest communication stack.
> > > > 
> > > > > Can you please move it back?
> > > > 
> > > > No objection from me here in general, though as Greg writes above, it's
> > > > a bit ugly when hvc_console.h is in a different directory.
> > > 
> > > Greg, can you do this please?  (A way to do it with preservig git
> > > history of the file would be great as well, but I think only a revert
> > > will do that?)
> > 
> > So just move the one file, virtio_console.c?  If so, yes, I can move it
> > back.
> 
> Yes, just the one file.

Ok, I'll queue that up later today.

thanks,

greg k-h
