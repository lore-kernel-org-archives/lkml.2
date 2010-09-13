Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0IMQYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:24:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40730 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752332Ab0IMQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:24:47 -0400
Date: Mon, 13 Sep 2010 12:24:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Phil Dibowitz <phil@ipom.com>
cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>, <stable@kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
In-Reply-To: <4C8E4B14.7090904@ipom.com>
Message-ID: <Pine.LNX.4.44L0.1009131219490.1315-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Phil Dibowitz wrote:

> Thanks for figuring this out Alan. I think this is reasonable. However, I
> think this also went into .32-stable and should probably be reverted there
> as well.

I think kernels earlier than .34 will be okay.  The changeover to the
runtime-PM framework occurred during the .33-.35 timeframe, and so .34
was in an intermediate state.

Jiri, as a workaround for people using the current 3.6.34.stable, you
can ask them to do:

	echo on >/sys/bus/usb/devices/.../power/level

with the "..." filled in appropriately.

> I'll advise my users to make sure they have at least .35.

That probably isn't necessary.

Alan Stern

