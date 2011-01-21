Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1AUJ76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:59:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:37408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1AUJ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:59:56 -0500
Date: Fri, 21 Jan 2011 10:59:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] HID: Report Descriptor in Sysfs
In-Reply-To: <1295590785-7101-1-git-send-email-alan@signal11.us>
Message-ID: <alpine.LNX.2.00.1101211054210.5725@pobox.suse.cz>
References: <1295590785-7101-1-git-send-email-alan@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Alan Ott wrote:

> So I'd like to have access to the HID report descriptor in a sysfs entry, so
> I can read it without opening the device.  hid-core seemed like the place to
> put it.
> 
> Using the /sys/class links, for hidraw devices, this puts a new file,
> report_descriptor in the directory:
> 	/sys/class/hidraw/hidraw0/device/
> 
> For my USB device (for example), the new file is in:
> 	/sys/bus/usb/devices/1-5.3:1.0/0003:046D:C216.0001/
> 
> For my Bluetooth device, the new file is in:
> 	/sys/class/bluetooth/hci0/hci0:11/0005:054C:0268.0002/
> 
> I'm not super confident that these file locations are the best place, but I
> made a best guess so that it could be discussed.  The current location is
> where the hid-core stuff lives.  Is there a reason these directories are
> named bus:vendor:product:id (instead of hid-core or something similar)?  Is
> there a better way to do this?

Hi Alan,

the report descriptor is provided through debugfs HID interface already. 
Do you feel like that's not enough?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
