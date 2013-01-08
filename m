Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3AHPvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:51:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34934 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756299Ab3AHPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:51:21 -0500
Date: Tue, 8 Jan 2013 10:51:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Josh Boyer <jwboyer@redhat.com>
cc: gregkh@linuxfoundation.org, <laurent.pinchart@ideasonboard.com>,
        <mdharm-usb@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: USB autosuspend vs. URB submission
In-Reply-To: <20130107204220.GB12363@hansolo.jdub.homelinux.org>
Message-ID: <Pine.LNX.4.44L0.1301081047170.1535-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Josh Boyer wrote:

> Hi,
> 
> We've had a few reports in Fedora of users hitting the WARN_ONCE in
> drivers/usb/core/urb.c that prints a warning about a usb_submit_urb
> being called on an active URB.  One of them[1] is from the ums_realtek
> driver and the other[2] is from the uvcvideo driver.  However, I noticed
> that in both instances it seems the devices were coming back from what I
> think is autosuspend.
> 
> I didn't immediately find any similar reports, and to my rather
> inexperienced eyes the drivers didn't seem to be doing anything clearly
> wrong.  I'm wondering if anyone has some possible ideas for debugging
> and whether or not this might be a general issue?

I don't see anything wrong either.

Can you ask the users to collect a usbmon trace covering the period 
when the problem occurs?

Alan Stern

