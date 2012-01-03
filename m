Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2ACSZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:25:13 -0500
Received: from RATBERT.FHCRC.ORG ([140.107.152.19]:40602 "EHLO
	ratbert.fhcrc.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2ACSZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:25:11 -0500
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jan 2012 13:25:11 EST
Date: Tue, 3 Jan 2012 10:16:21 -0800 (PST)
From: "Pitt, Jason N" <jpitt@fhcrc.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-uvc-devel@lists.berlios.de
Message-ID: <1788809778.116537.1325614581565.JavaMail.root@zimbra2.fhcrc.org>
In-Reply-To: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com>
Subject: Re: [Linux-uvc-devel] 3.1.5: uvcvideo: Failed to resubmit video URB
 (-27).
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [140.107.89.37]
X-Mailer: Zimbra 6.0.10_GA_2692 (zclient/6.0.10_GA_2692)
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.1.3.180618
X-FHCRC-SCANNED: Tue Jan  3 10:16:21 2012
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.1.3.180618
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the output of lsusb?



--- Original Message -----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Cc: linux-uvc-devel@lists.berlios.de
Sent: Tue, 03 Jan 2012 06:21:02 -0800 (PST)
Subject: [Linux-uvc-devel] 3.1.5: uvcvideo: Failed to resubmit video URB (-27).
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
 bLength 18
 bDescriptorType 1
 bcdUSB 2.00
 bDeviceClass 239 Miscellaneous Device
 bDeviceSubClass 2 ?
 bDeviceProtocol 1 Interface Association
 bMaxPacketSize0 64
 idVendor 0x0402 ALi Corp.
 idProduct 0x9665 Gateway Webcam
 bcdDevice 0.09
 iManufacturer 3 XPB3L1K44
 iProduct 1 1.3M WebCam
 iSerial 0
 bNumConfigurations 1
Justin.
_______________________________________________
Linux-uvc-devel mailing list
Linux-uvc-devel@lists.berlios.de
https://lists.berlios.de/mailman/listinfo/linux-uvc-devel
-- 
/*
Jason Pitt PhD 206.667.5603
Roth Lab jpitt@fhcrc.org
Basic Sciences Division 
Fred Hutchinson Cancer Research Center
1100 Fairview Ave N A3-135
Seattle, WA 98109
*/
