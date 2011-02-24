Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1BXOzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:55:16 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43004 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751835Ab1BXOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:55:13 -0500
Date: Thu, 24 Feb 2011 09:55:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: btusb autosuspend (was Re: Linux 2.6.38-rc6)
In-Reply-To: <20110224004333.GA22698@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1102240953320.2084-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Matthew Garrett wrote:

> On Wed, Feb 23, 2011 at 04:25:23PM -0800, Linus Torvalds wrote:
> > Hmm. Is there any reason we shouldn't revert commit
> > 556ea928f78a390fe16ae584e6433dff304d3014 given the regression?
> 
> I think reverting makes sense at the moment. I haven't seen the reported 
> issues - I need to figure out if this is related to bus powered/self 
> powered devices, or what else is causing the difference.
> 
> > It apparently had problems before too, and caused autosuspend to be
> > disabled entirely, judging at least by
> > 
> >   https://bugzilla.redhat.com/show_bug.cgi?id=528744
> > 
> > but there's obviously the comment about "those should be fixed now".
> > Apparently there are more issues.
> 
> Right, we were autosuspending even when there were active connections. 
> Marcel told me that ought to be fixed and my testing seemed to agree...
> 
> > I have no idea whether this is a USB-level issue, or a driver-level
> > one. There are no comments about exactly what fixed the input device
> > issues. So I'm adding both BT and USB people to the discussion.
> 
> I'll try to get time to look at this this week. Marcel, any ideas?

Take a look at Bugzilla #26182.  I tried adding your address to the CC: 
list, but the only address I could find that Bugzilla would accept 
wasn't the same as the addresses you normally use.

Alan Stern

