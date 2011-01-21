Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1AUQOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:14:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:48800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1AUQOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:14:43 -0500
Date: Fri, 21 Jan 2011 17:14:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] HID: Report Descriptor in Sysfs
In-Reply-To: <4D39A660.7040302@signal11.us>
Message-ID: <alpine.LNX.2.00.1101211714050.5725@pobox.suse.cz>
References: <1295590785-7101-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1101211054210.5725@pobox.suse.cz> <4D399DAB.3080808@signal11.us> <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz> <4D39A660.7040302@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Alan Ott wrote:

> Well, what I really want is the Usage Page and Usage of the device. For some
> background, I maintain a library called hidapi[1] for accessing HID devices in
> a cross platform way. There are currently four backends, Linux-hidraw,
> Linux-libusb, Mac OS, and Windows.
> 
> I've recently received requests for supporting composite HID devices. Since a
> composite device will show up as multiple devices with the same VID/PID, one
> needs a way to differentiate between its different interfaces. On Windows and
> Mac, the platform HID libraries support getting the Usage Page and Usage of
> each interface. On Linux/libusb I can request the HID report descriptor and
> parse it myself, but I have to claim the interface to do it, and to do that, I
> have to detach the kernel driver. Needless to say, detaching the kernel driver
> is not good, especially when the library is supposed to be just scanning for
> devices.
> 
> For these reasons, it would be really convenient to get the report descriptor
> from sysfs.

In this case, you can still get the report descriptor from hidraw (which 
is parallel to any other HID-bus based kernel driver). Woudl that suit 
your needs?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
