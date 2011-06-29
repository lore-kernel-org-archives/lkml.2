Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1F2JVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:21:41 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:41244 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1F2JVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:21:36 -0400
Date: Wed, 29 Jun 2011 13:20:01 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into
	ehci-sysfs.c
Message-ID: <20110629092001.GC10219@tugrik.mns.mnsspb.ru>
References: <2a537d4dffef27cc7839eb19889eaa035edd44f9.1308933456.git.kirr@mns.spb.ru> <Pine.LNX.4.44L0.1106250807270.1039-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106250807270.1039-100000@netrider.rowland.org>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 25, 2011 at 08:10:52AM -0400, Alan Stern wrote:
> On Fri, 24 Jun 2011, Kirill Smelkov wrote:
> 
> > The only sysfs attr implemented so far is "companion" from ehci-hub.c,
> > but in the next patch we are going to add another sysfs file, so prior
> > to that let's structure things and move already-in-there sysfs code to
> > separate file.
> > 
> > Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> > diff --git a/drivers/usb/host/ehci-sysfs.c b/drivers/usb/host/ehci-sysfs.c
> > new file mode 100644
> > index 0000000..347c8cb
> > --- /dev/null
> > +++ b/drivers/usb/host/ehci-sysfs.c
> > @@ -0,0 +1,94 @@
> > +/*
> > + * Copyright (C) 2001-2004 by David Brownell
> 
> One little note...  It's understandable that you put this line here,
> but it isn't really appropriate.  All the code you're moving into this
> new file was written by me.

Now I see, yes, in 57e06c11 (EHCI: force high-speed devices to run at
full speed; Jan 16 2007).

> Apart from that one issue,
> 
> Acked-off-by: Alan Stern <stern@rowland.harvard.edu>

Thanks.

What should we do with this patch now? Should I put


    Copyright (C) 2007 by Alan Stern

there? Or something else?

Or maybe drop that copyright notice altogether becase usually it gets
outdated very quickly, and who made what is visible through git
log/blame?


I'm ok with any case, please just tell me how to proceed.


And what about main "[PATCH v2 2/2] USB: EHCI: Allow users to override
80% max periodic bandwidth"?

Was it Acked together with this one, or not and review is pending?
Curious because I'm new here...


Thanks,
Kirill
