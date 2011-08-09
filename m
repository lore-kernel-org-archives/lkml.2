Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1HIQAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:00:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38402 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753011Ab1HIQA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:00:29 -0400
Date: Tue, 9 Aug 2011 12:00:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-bluetooth@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] BTUSB: be quiet on device disconnect
In-Reply-To: <1312902988.1853.24.camel@x61.thuisdomein>
Message-ID: <Pine.LNX.4.44L0.1108091159050.1949-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Paul Bolle wrote:

> 1) I added Greg and linux-usb@vger.kernel.org because usb_submit_urb()
> doesn't specify the meaning of its negative return values. I traced

In fact, many of these values are documented in 
Documentation/usb/error-codes.txt.

> -EPERM to usb_hcd_link_urb_to_ep(). That returns -EPERM if the urb is
> "being killed". Did I trace the calls made by usb_submit_urb()
> correctly? I also just assumed that -ENODEV always means device got
> disconnected or something comparable. Is that correct too?

Yes, those are both correct.

Alan Stern

