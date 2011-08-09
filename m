Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1HIU0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:26:25 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34481 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1HIU0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:26:24 -0400
Subject: Re: [PATCH] [RFC] BTUSB: be quiet on device disconnect
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-bluetooth@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2011 22:26:08 +0200
In-Reply-To: <Pine.LNX.4.44L0.1108091159050.1949-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1108091159050.1949-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312921583.30382.12.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 12:00 -0400, Alan Stern wrote:
> On Tue, 9 Aug 2011, Paul Bolle wrote:
> > 1) I added Greg and linux-usb@vger.kernel.org because usb_submit_urb()
> > doesn't specify the meaning of its negative return values. I traced
> 
> In fact, many of these values are documented in 
> Documentation/usb/error-codes.txt.

0) Thanks. I hadn't found that, obviously.

1) Would it make sense to add links to that file in the documentation
for usb_submit_urb() and other core usb functions? (Does the kernel-doc
syntax have a notation for links?) I only do hit-and-run patches in the
usb subsystem, and any other subsystem, for that matter, so I'm not sure
that what I like to see is what's actually needed.


Paul Bolle

