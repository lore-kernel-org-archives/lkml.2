Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3AHQDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:03:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab3AHQDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:03:31 -0500
Date: Tue, 8 Jan 2013 11:03:22 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com,
        mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: USB autosuspend vs. URB submission
Message-ID: <20130108160321.GC12363@hansolo.jdub.homelinux.org>
References: <20130107204220.GB12363@hansolo.jdub.homelinux.org>
 <Pine.LNX.4.44L0.1301081047170.1535-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301081047170.1535-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 10:51:20AM -0500, Alan Stern wrote:
> On Mon, 7 Jan 2013, Josh Boyer wrote:
> 
> > Hi,
> > 
> > We've had a few reports in Fedora of users hitting the WARN_ONCE in
> > drivers/usb/core/urb.c that prints a warning about a usb_submit_urb
> > being called on an active URB.  One of them[1] is from the ums_realtek
> > driver and the other[2] is from the uvcvideo driver.  However, I noticed
> > that in both instances it seems the devices were coming back from what I
> > think is autosuspend.
> > 
> > I didn't immediately find any similar reports, and to my rather
> > inexperienced eyes the drivers didn't seem to be doing anything clearly
> > wrong.  I'm wondering if anyone has some possible ideas for debugging
> > and whether or not this might be a general issue?
> 
> I don't see anything wrong either.
> 
> Can you ask the users to collect a usbmon trace covering the period 
> when the problem occurs?

I'll certainly ask.  I'm not particularly hopeful for great results
though, as the problems seem to be rather intermittent.

Thanks for taking a look.

josh
