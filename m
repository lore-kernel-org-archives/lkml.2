Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0C3XZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:25:10 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:38240 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab0C3XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:25:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Subject: Re: webcam problem after suspend/hibernate
Date: Wed, 31 Mar 2010 01:25:25 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33; KDE/4.4.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
In-Reply-To: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003310125.26266.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohamed,

On Tuesday 30 March 2010 23:55:38 Mohamed Ikbel Boulabiar wrote:
> Hi,
> 
> After suspend/resume, I have my webcam no more working.
> The /dev/video0 file still exist, but the webcam won't be used until I do
> this : rmmod     uvcvideo
> modprobe uvcvideo
> (2.6.31.8-0.1)
> 
> This is may be caused by a bug somewhere.
> These are more information about my hardware :
> 
> I have Microdia webcam
> `lsusb`
> Bus 001 Device 004: ID 0c45:62c0 Microdia Sonix USB 2.0 Camera
> 
> on openSUSE 11.2 `uname -a`
> Linux linux-l365 2.6.31.8-0.1-desktop #1 SMP PREEMPT 2009-12-15
> 23:55:40 +0100 i686 i686 i386 GNU/Linux
> 
> `hwinfo --usb`
> 
> : USB 00.0: 0000 Unclassified device
> 
>   [Created at usb.122]
>   UDI:
> /org/freedesktop/Hal/devices/usb_device_c45_62c0_1_3_2_1_7_if0_logicaldev_
> input Unique ID: Uc5H.F0c0EBqBP10
>   Parent ID: k4bc.9T1GDCLyFd9
>   SysFS ID: /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4:1.0
>   SysFS BusID: 1-4:1.0
>   Hardware Class: unknown
>   Model: "Microdia LG Webcam"
>   Hotplug: USB
>   Vendor: usb 0x0c45 "Microdia"
>   Device: usb 0x62c0 "LG Webcam"
>   Revision: "32.17"
>   Serial ID: "1.3.2.1.7"
>   Driver: "uvcvideo"
>   Driver Modules: "uvcvideo"
>   Device File: /dev/input/event8
>   Device Files: /dev/input/event8, /dev/char/13:72,
> /dev/input/by-id/usb-LG_Innotek_LG_Webcam_1.3.2.1.7-event-if00,
> /dev/input/by-path/pci-0000:00:1d.7-usb-0:4:1.0-event
>   Device Number: char 13:72
>   Speed: 480 Mbps
>   Module Alias: "usb:v0C45p62C0d3217dcEFdsc02dp01ic0Eisc01ip00"
>   Driver Info #0:
>     Driver Status: uvcvideo is active
>     Driver Activation Cmd: "modprobe uvcvideo"
>   Config Status: cfg=no, avail=yes, need=no, active=unknown
>   Attached to: #4 (Hub)
> 
> 
> If there is a scenario you propose me to do to detect from where comes
> the problem, I can apply it.

Could you please post the messages printed by the uvcvideo driver and USB core 
to the kernel log when you suspend and resume your system ? Thanks.

-- 
Regards,

Laurent Pinchart
