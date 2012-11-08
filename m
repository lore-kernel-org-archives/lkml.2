Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab2KHPz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:55:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55575 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756182Ab2KHPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:55:51 -0500
Date: Thu, 8 Nov 2012 10:55:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Takashi Iwai <tiwai@suse.de>
cc: Daniel Mack <zonque@gmail.com>, Christof Meerwald <cmeerw@cmeerw.org>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
In-Reply-To: <s5hr4o4frcf.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.44L0.1211081054340.1280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Takashi Iwai wrote:

> At Thu, 08 Nov 2012 08:31:35 +0100,
> Daniel Mack wrote:
> (snip)
> > >> We can't simply stop both endpoints in the prepare callback.
> > > 
> > > The new function doesn't stop the stream by itself but it just syncs
> > > if the stream is being stopped beforehand.  So, it's safe to call it
> > > there.
> > > 
> > > Maybe the name was confusing.  It should have been like
> > > snd_usb_endpoint_sync_pending_stop() or such.
> > 
> > Ah, right. I was errornously looking closer to Alan's patch but then
> > replied to yours. Alright then - thanks for explaining :)
> 
> OK, thanks for checking.
> 
> FWIW, below is the patch I applied now to for-linus branch.
> Renamed the function, added the comment and put NULL check to the
> function to simplify.

Thanks for fixing this.  Is your patch marked for -stable?

I have submitted a patch for ehci-hcd, so we should be all set.

Alan Stern

