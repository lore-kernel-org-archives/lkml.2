Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1FPRGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:06:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60724 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756832Ab1FPRGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:06:13 -0400
Date: Thu, 16 Jun 2011 13:06:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Tatyana Brokhman <tlinder@codeaurora.org>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 2/5] usb:dummy_hcd: connect/disconnect test support
In-Reply-To: <20110616161626.GV12230@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1106161303540.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Felipe Balbi wrote:

> Hi,
> 
> On Thu, Jun 16, 2011 at 11:06:47AM -0400, Alan Stern wrote:
> > On Thu, 16 Jun 2011, Tatyana Brokhman wrote:
> > 
> > > This implementation adds a new proprietary device control requests (to be
> > > handled by the dummy_hcd) that initiates a connect/disconnect sequence.
> > > The bRequest value of the new control request is 0x52.
> > > It is used by the user-space Unit testing application.
> > 
> > This is not a bad idea.  On the other hand, it is slightly peculiar -- 
> > it you're testing with real UDC hardware, you would do the 
> > disconnect/reconnect sequence by hand (unplug and replug the USB 
> > cable), not in software.
> 
> actually, this is quite useful. Specially for the controllers which
> _can_ do soft-connect by toggling data pullups. I would rather have
> these sort of thing maybe in composite.c, so that we can build tests
> with all gadget drivers/controllers, not only dummy_hcd.

It sounds like you don't understand the point of this patch.  It allows
the _host_ to control the pullup settings.

Alan Stern

