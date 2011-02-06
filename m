Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1BFUDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:03:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab1BFUDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:03:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] PM: Do not create wakeup sysfs files for devices that cannot wake up (v2)
Date: Sun, 6 Feb 2011 21:03:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>
References: <Pine.LNX.4.44L0.1102061024150.20379-100000@netrider.rowland.org> <201102061953.17433.rjw@sisk.pl> <20110206191421.GB7818@kroah.com>
In-Reply-To: <20110206191421.GB7818@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102062103.12139.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011, Greg KH wrote:
> On Sun, Feb 06, 2011 at 07:53:17PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, February 06, 2011, Alan Stern wrote:
> > > On Sun, 6 Feb 2011, Rafael J. Wysocki wrote:
> > > 
> > > > Hi,
> > > > 
> > > > Below is the next version of the patch changing the PM core to only create
> > > > wakeup sysfs files for devices that are wakeup-capable.  It contains a change
> > > > in drivers/usb/core/hub.c that should avoid the problem described in the thread
> > > > at https://lkml.org/lkml/2011/2/5/108 , but I'm not 100% it's the right
> > > > approach.  Please have a look.
> > > 
> > > Yes, that's right -- in fact, it's exactly the same as what I was going
> > > to do.  Of course, it should be separated out into a separate patch, to
> > > be applied before the other wakeup changes.
> > 
> > OK, I'll split it out.
> > 
> > Greg, any objections to me putting the change below into the suspend tree as
> > a separate commit:
> 
> No objection from me at all:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks!

Rafael
