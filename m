Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1KVVCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:02:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36719 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753263Ab1KVVCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:02:50 -0500
Date: Tue, 22 Nov 2011 16:02:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5] PM: Update comments describing device power management
 callbacks
In-Reply-To: <201111222147.32303.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1111221600580.2466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Rafael J. Wysocki wrote:

> > The same data structure (dev_pm_ops) is used for both drivers and
> > subsystems.  Therefore the comments should be directed toward both
> > driver writers and subsystem writers.
> 
> I don't quite agree.  Trying to do so would turn that comment into a lengthy
> document and there's no room for anything like that in the header file.

That's a good point.

> Perhaps I'll just modify the comment to say when the callbacks are executed
> without specifying what the specific callbacks are supposed to do (because
> that may vary from one subsystem to another and even between different
> drivers belonging to the same subsystem).  If PM domains are taken into
> account, it gets even more complicated.

Yes, a minimal description would be good, along with a pointer to the 
Documentation/power files.

> > It won't be moot if you add the sentences I recommend above.  You could
> > add an additional sentence: "Either way, the @freeze() and
> > @freeze_noirq() callbacks (both the subsystem's and the driver's)  
> > should always avoid changing the device's state."
> 
> That sounds good.

Actually I meant to write "avoid changing the device's power state".

Alan Stern

