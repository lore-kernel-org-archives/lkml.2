Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2LKUhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:37:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50696 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753915Ab2LKUhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:37:33 -0500
Date: Tue, 11 Dec 2012 15:37:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: prasannatsmkumar <prasannatsmkumar@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <nautilus-list@gnome.org>
Subject: Re: Fwd: Safely remove option shows with Micro SD Card connected to
 Linux through an Android phone
In-Reply-To: <CANc+2y50-AYJcJgeQ8JHJiMjwxg=tbkQ2HQR4=ZZsEthKiWXgw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1212111530250.1180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012, prasannatsmkumar wrote:

> Hi All,
> 
> I connected an Android phone using USB cable to my machine running
> Linux (Linux 3.0, 3.2, 3.5). Mounted the SD card in phone in system
> (phone is just a pass through I guess). When I choose "Safely Remove"
> option in nautilus file manager (gnome's default file manager) I got
> an error saying
> 
> "Error detaching: helper exited with exit code 1: Detaching device /dev/sdb
> USB device: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5)
> SYNCHRONIZE CACHE: OK
> STOP UNIT: FAILED: No such file or directory"

STOP UNIT means spin down the disk or eject the disc.  Since your phone
doesn't have a disk drive or an optical disc, no wonder this step
failed.

> and it goes to unmounted state (yes it should go to and this is not a
> problem). But I am not able to find the reason for the above error
> message pop-up. If I choose "Eject" option then things are fine (I
> think Eject does more than un-mounting the file system).
> 
> I think "safely remove" tries to cut the power supply to the device
> but eject does not do that. Is that correct?

No, neither option cuts power.  The main difference is that "safely
remove" disables the USB connection, so that if the device has an "okay
to unplug now" light, the light will turn on.

> If the device cannot be
> powered down (due to battery charging) why this option is shown? Is
> kernel exposing such capability to the user space?
> 
> I am not sure whether this is the correct place to ask this question.
> If this is not the correct place please direct me to correct place.

You probably should get in touch with the people who maintain the 
Nautilus program if you want to know why it does something.

Alan Stern

