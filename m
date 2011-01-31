Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1AaWRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:17:18 -0500
Received: from kroah.org ([198.145.64.141]:53640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab1AaWRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:17:16 -0500
Date: Mon, 31 Jan 2011 14:14:54 -0800
From: Greg KH <greg@kroah.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Message-ID: <20110131221454.GA14884@kroah.com>
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
> 
> > > > > I could perhaps think of a way of splitting the file so the hvc bits can
> > > > > be moved to drivers/tty/hvc/ and having the core stay in drivers/char/,
> > > > > but that'll have to wait for the next cycle.
> > 
> > That would be great, care to send me those patches now so I can queue it
> > up for .39?
> 
> It was just a thought; I don't have patches yet.  I'll send them your
> way once they're ready.

Actually, can you send me the patch to do this rename back now?  I can't
test the build to verify that I got it correct, and I'd like to properly
credit you with it as well.

thanks,

greg k-h
