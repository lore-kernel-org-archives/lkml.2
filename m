Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab2KBPjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:39:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59642 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2KBPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:39:30 -0400
Date: Fri, 2 Nov 2012 08:39:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Beulich <JBeulich@suse.com>, sfr@canb.auug.org.au,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 31 (ehci, dbgp)
Message-ID: <20121102153931.GA3755@kroah.com>
References: <5093E0DF02000078000A6102@nat28.tlf.novell.com>
 <Pine.LNX.4.44L0.1211021019450.1356-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1211021019450.1356-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:20:27AM -0400, Alan Stern wrote:
> On Fri, 2 Nov 2012, Jan Beulich wrote:
> 
> > >>> On 02.11.12 at 15:01, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Thu, 1 Nov 2012, Jan Beulich wrote:
> > > 
> > >> >>> Alan Stern <stern@rowland.harvard.edu> 11/01/12 9:39 PM >>>
> > >> >On Thu, 1 Nov 2012, Jan Beulich wrote:
> > >> >> >>> Alan Stern <stern@rowland.harvard.edu> 11/01/12 4:28 PM >>>
> > >> >> >Evidently we need to change your new test in
> > >> >> >drivers/usb/early/ehci-dbgp.c to:
> > >> >> >
> > >> >> >#if IS_ENABLED(CONFIG_USB_HCD_EHCI) || defined(CONFIG_USB_CHIPIDEA_HOST)
> > >> >> >
> > >> >> >Upcoming changes to ehci-hcd will make this unnecessary in 3.8, but for 
> > >> >> >now we need it.
> > >> >> 
> > >> >> Which tells me that the CONFIG_USB_SUPPORT version would have been
> > >> >> the better one  (and I would favor that over the ugly variant you suggest
> > >> >> above).
> > >> >
> > >> >I also suggested IS_ENABLED(CONFIG_USB), which is no uglier than what 
> > >> >you submitted and would also fix this build error.  How about using it 
> > >> >instead?
> > >> 
> > >> Yes, that's better. Question then is - updated original patch or incremental 
> > > one?
> > > 
> > > Greg will probably want an incremental patch, because the original has 
> > > already been merged.
> > 
> > I actually sent both (the incremental as attachment - I hope that's
> > going to be acceptable to him) in a submission earlier today.
> 
> Ah, okay, good.
> 
> Greg, whichever version you take, you can add:
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks for that, as you guessed, I have to take the incremental one as
the first is already applied.

greg k-h
