Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0C3V4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 17:56:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46318 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0C3V4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 17:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=nwHk+DgO92lKpJ87LEm8fRSVPicVXBEPNtyJp2vMb+6faEzjatEsB1n7lvs35qeny0
         R52RpLvLImDARkvoU2HxemazBzK5CRBA6DGwzFXMz1dzMjrNUUbVL79+NwyiUfyDR146
         I3KjIeBuFek5jHJfiVT28/D/nUexm86ZDYWY4=
MIME-Version: 1.0
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Tue, 30 Mar 2010 23:55:38 +0200
Message-ID: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
Subject: webcam problem after suspend/hibernate
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After suspend/resume, I have my webcam no more working.
The /dev/video0 file still exist, but the webcam won't be used until I do this :
rmmod     uvcvideo
modprobe uvcvideo
(2.6.31.8-0.1)

This is may be caused by a bug somewhere.
These are more information about my hardware :

I have Microdia webcam
`lsusb`
Bus 001 Device 004: ID 0c45:62c0 Microdia Sonix USB 2.0 Camera

on openSUSE 11.2 `uname -a`
Linux linux-l365 2.6.31.8-0.1-desktop #1 SMP PREEMPT 2009-12-15
23:55:40 +0100 i686 i686 i386 GNU/Linux

`hwinfo --usb`
: USB 00.0: 0000 Unclassified device
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_c45_62c0_1_3_2_1_7_if0_logicaldev_input
  Unique ID: Uc5H.F0c0EBqBP10
  Parent ID: k4bc.9T1GDCLyFd9
  SysFS ID: /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4:1.0
  SysFS BusID: 1-4:1.0
  Hardware Class: unknown
  Model: "Microdia LG Webcam"
  Hotplug: USB
  Vendor: usb 0x0c45 "Microdia"
  Device: usb 0x62c0 "LG Webcam"
  Revision: "32.17"
  Serial ID: "1.3.2.1.7"
  Driver: "uvcvideo"
  Driver Modules: "uvcvideo"
  Device File: /dev/input/event8
  Device Files: /dev/input/event8, /dev/char/13:72,
/dev/input/by-id/usb-LG_Innotek_LG_Webcam_1.3.2.1.7-event-if00,
/dev/input/by-path/pci-0000:00:1d.7-usb-0:4:1.0-event
  Device Number: char 13:72
  Speed: 480 Mbps
  Module Alias: "usb:v0C45p62C0d3217dcEFdsc02dp01ic0Eisc01ip00"
  Driver Info #0:
    Driver Status: uvcvideo is active
    Driver Activation Cmd: "modprobe uvcvideo"
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #4 (Hub)


If there is a scenario you propose me to do to detect from where comes
the problem, I can apply it.
Thanks,

ik.
