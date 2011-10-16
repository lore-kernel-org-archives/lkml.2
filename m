Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1JPOSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 10:18:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35130 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753115Ab1JPOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 10:18:28 -0400
Date: Sun, 16 Oct 2011 10:18:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <20111016091009.GB32551@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1110161017040.28864-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011, Johannes Stezenbach wrote:

> On Sat, Oct 15, 2011 at 03:04:28PM -0400, Alan Stern wrote:
> > On Sat, 15 Oct 2011, Johannes Stezenbach wrote:
> > 
> > > What I meant to say is Markus' statement that the device only
> > > works at a certain transfer size cannot be true since
> > > this size is not visible to the device via the USB bus.
> > 
> > That's what I would expect, too.  But did you take a look at the usbmon 
> > traces Markus acquired?
> > 
> > 	http://marc.info/?l=linux-usb&m=131845614819045&w=2
> 
> I glanced at them for 3 seconds, but I cannot be bothered
> to analyze them in detail.  The ASCII usbmon traces don't
> show full USB packet contents anyway so you can't see if
> partial MPEG TS packets are missing.

> The device transfers data in the "not working" case, it's just that
> the MPEG TS sync byte is not where Markus expects it, which could
> be explained by a partial MPEG TS packet left in the device's FIFO
> from previous interaction.

But why does this happen only when the transfer size is different from
24064?  Why doesn't it also happen when the transfer size _is_ 24064?

Alan Stern

