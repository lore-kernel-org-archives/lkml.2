Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1ECNtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:49:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47573 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751903Ab1ECNtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:49:13 -0400
Date: Tue, 3 May 2011 09:49:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Adi J. Sieker" <adi@core.adi.io>
cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
In-Reply-To: <4DBFCD88.6020900@sieker.io>
Message-ID: <Pine.LNX.4.44L0.1105030945410.2085-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011, Adi J. Sieker wrote:

> Do you know of a way for me to tell the kernel/usbhid to use interface 1 
> and ignore interface 0?

Well, you can always unbind interface 0 from usbhid -- it corresponds
to the 2-1.1:1.0 file in /sys/bus/usb/drivers/usbhid/.  If you do that,
you'll probably find the few keys which _do_ currently work suddenly
stop working.

But there's nothing to be done immediately about interface 1; usbhid is
_already_ using it.  It just isn't using it correctly.

Alan Stern

