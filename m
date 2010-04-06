Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0DFPIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:08:48 -0400
Received: from lucidpixels.com ([75.144.35.66]:45714 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0DFPIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:08:43 -0400
Date: Tue, 6 Apr 2010 11:08:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.33.2: USB Quickcam Pro 9000 (usb resets)?
In-Reply-To: <Pine.LNX.4.44L0.1004061057240.1722-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1004061108100.20297@p34.internal.lan>
References: <Pine.LNX.4.44L0.1004061057240.1722-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Alan Stern wrote:

> On Tue, 6 Apr 2010, Justin Piszcz wrote:
>
>> So the USB hub is shared amongst the ports in the back of the board that
>> I am using:
>>
>> Port 1-> keyboard/mouse
>> Port 2-> USB hub -> webcam
>> Port 3-> UPS (but not using nut at the moment, just hooked up)
>>
>> $ lsusb
>> Bus 001 Device 023: ID 0461:4d15 Primax Electronics, Ltd Dell Optical Mouse
>> Bus 001 Device 022: ID 413c:2002 Dell Computer Corp. SK-8125 Keyboard
>> Bus 001 Device 005: ID 046d:0990 Logitech, Inc. QuickCam Pro 9000
>> Bus 001 Device 004: ID 413c:1002 Dell Computer Corp. Keyboard Hub
>> Bus 001 Device 003: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub
>> Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 002 Device 003: ID 051d:0002 American Power Conversion Uninterruptible Power Supply
>> Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
>> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>>
>> Any recommendations/workarounds how to fix or just ignore it?
>
> You could plug the webcam into bus 2 while leaving the keyboard/mouse
> attached to bus 1.
>
> You could try using different ports on the D-Link 7-port hub, or try
> replacing that hub with a different brand.
>
> Alan Stern
>

Hi Alan,

Will try a different port (so its on BUS 2) for the PC.
The d-Link hub is a brand new hub (fyi) with only 1 device attached, the 
webcam but will give it a try, thanks.

Justin.
