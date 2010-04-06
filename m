Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab0DFO76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:59:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53961 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750708Ab0DFO7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:59:52 -0400
Date: Tue, 6 Apr 2010 10:59:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.33.2: USB Quickcam Pro 9000 (usb resets)?
In-Reply-To: <alpine.DEB.2.00.1004060533460.12641@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1004061057240.1722-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010, Justin Piszcz wrote:

> So the USB hub is shared amongst the ports in the back of the board that
> I am using:
> 
> Port 1-> keyboard/mouse
> Port 2-> USB hub -> webcam
> Port 3-> UPS (but not using nut at the moment, just hooked up)
> 
> $ lsusb
> Bus 001 Device 023: ID 0461:4d15 Primax Electronics, Ltd Dell Optical Mouse
> Bus 001 Device 022: ID 413c:2002 Dell Computer Corp. SK-8125 Keyboard
> Bus 001 Device 005: ID 046d:0990 Logitech, Inc. QuickCam Pro 9000
> Bus 001 Device 004: ID 413c:1002 Dell Computer Corp. Keyboard Hub
> Bus 001 Device 003: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub
> Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 003: ID 051d:0002 American Power Conversion Uninterruptible Power Supply
> Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> 
> Any recommendations/workarounds how to fix or just ignore it?

You could plug the webcam into bus 2 while leaving the keyboard/mouse 
attached to bus 1.

You could try using different ports on the D-Link 7-port hub, or try
replacing that hub with a different brand.

Alan Stern

