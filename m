Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2LKSEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:04:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45293 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2LKSEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:04:38 -0500
MIME-Version: 1.0
In-Reply-To: <CANc+2y5iLuZG5wPab5Hf0-mAngpkO+72XZR3FK9kgR8-kAKZ1Q@mail.gmail.com>
References: <CANc+2y5iLuZG5wPab5Hf0-mAngpkO+72XZR3FK9kgR8-kAKZ1Q@mail.gmail.com>
Date: Tue, 11 Dec 2012 23:34:36 +0530
Message-ID: <CANc+2y50-AYJcJgeQ8JHJiMjwxg=tbkQ2HQR4=ZZsEthKiWXgw@mail.gmail.com>
Subject: Fwd: Safely remove option shows with Micro SD Card connected to Linux
 through an Android phone
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nautilus-list@gnome.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I connected an Android phone using USB cable to my machine running
Linux (Linux 3.0, 3.2, 3.5). Mounted the SD card in phone in system
(phone is just a pass through I guess). When I choose "Safely Remove"
option in nautilus file manager (gnome's default file manager) I got
an error saying

"Error detaching: helper exited with exit code 1: Detaching device /dev/sdb
USB device: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5)
SYNCHRONIZE CACHE: OK
STOP UNIT: FAILED: No such file or directory"

and it goes to unmounted state (yes it should go to and this is not a
problem). But I am not able to find the reason for the above error
message pop-up. If I choose "Eject" option then things are fine (I
think Eject does more than un-mounting the file system).

I think "safely remove" tries to cut the power supply to the device
but eject does not do that. Is that correct? If the device cannot be
powered down (due to battery charging) why this option is shown? Is
kernel exposing such capability to the user space?

I am not sure whether this is the correct place to ask this question.
If this is not the correct place please direct me to correct place.

Note: Previous attempt to send this mail to linux-kernel and linux-usb
mailing list failed. So resending this again. Please bear with me
nautilus-list people.

Thanks and Regards,
PrasannaKumar
