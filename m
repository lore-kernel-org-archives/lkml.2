Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2GJMos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:44:48 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60554 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2GJMor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:44:47 -0400
Message-ID: <1341924202.31958.12.camel@aeonflux>
Subject: Re: [PATCH v2] Bluetooth: Add MacBookPro10,1 support
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrik Rydberg <rydberg@bitmath.se>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Date: Tue, 10 Jul 2012 09:43:22 -0300
In-Reply-To: <1341917201-4705-1-git-send-email-rydberg@euromail.se>
References: <1341917201-4705-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

> Add support for the 2012 15'' MacBook Pro Retina, also known as
> MacBookPro10,1. The bluetooth device presents itself as
> 
> Bus 002 Device 008: ID 05ac:8286 Apple, Inc.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          255 Vendor Specific Class
>   bDeviceSubClass         1
>   bDeviceProtocol         1
>   bMaxPacketSize0        64
>   idVendor           0x05ac Apple, Inc.
>   idProduct          0x8286
>   bcdDevice            0.74
>   iManufacturer           1 Apple Inc.
>   iProduct                2 Bluetooth USB Host Controller
>   iSerial                 0
>   bNumConfigurations      1

please use /sys/kernel/debug/usb/devices or usb-devices script so that
we get a compact representation of all endpoints and their descriptors.
I know that lsusb will contain the same information, but it just spams
the commit message for no real reason.

Regards

Marcel


