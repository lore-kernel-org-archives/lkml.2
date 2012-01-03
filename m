Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2ACOVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:21:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58106 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2ACOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:21:04 -0500
MIME-Version: 1.0
X-Originating-IP: [72.21.198.64]
Date: Tue, 3 Jan 2012 09:21:02 -0500
Message-ID: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com>
Subject: 3.1.5: uvcvideo: Failed to resubmit video URB (-27).
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Cc: linux-uvc-devel@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Using an Acer 7551-7442 here with the following built-in webcam:
Bus 002 Device 004: ID 0402:9665 ALi Corp. Gateway Webcam

It seems motion locks up every day or so and I see this in the kernel logs:
[378982.724053] uvcvideo: Failed to resubmit video URB (-27).
[378982.724066] uvcvideo: Failed to resubmit video URB (-27).
[378982.724079] uvcvideo: Failed to resubmit video URB (-27).
[378982.724090] uvcvideo: Failed to resubmit video URB (-27).
[378982.724101] uvcvideo: Failed to resubmit video URB (-27).
[489148.723367] uvcvideo: Failed to resubmit video URB (-27).
[489148.723379] uvcvideo: Failed to resubmit video URB (-27).
[489148.723391] uvcvideo: Failed to resubmit video URB (-27).
[489148.723403] uvcvideo: Failed to resubmit video URB (-27).
[489148.723414] uvcvideo: Failed to resubmit video URB (-27).

If I restart motion, it will usually start working again, I do not
have this problem on other (retail) Logitech webcams, was curious if
this a bug with the webcam (quirk?) or a problem in uvcvideo?

The camera is built-into the laptop screen at the top in the middle.

lsusb verbose:

Bus 002 Device 004: ID 0402:9665 ALi Corp. Gateway Webcam
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x0402 ALi Corp.
  idProduct          0x9665 Gateway Webcam
  bcdDevice            0.09
  iManufacturer           3 XPB3L1K44
  iProduct                1 1.3M WebCam
  iSerial                 0
  bNumConfigurations      1

Justin.
