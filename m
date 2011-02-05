Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1BEUQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:16:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52425 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752992Ab1BEUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:16:19 -0500
Date: Sat, 5 Feb 2011 15:16:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ed Tomlinson <edt@aei.ca>
cc: linux-kernel@vger.kernel.org, <linux-bluetooth@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [BUG] usb problems in .38-rc3+
In-Reply-To: <201102051417.58953.edt@aei.ca>
Message-ID: <Pine.LNX.4.44L0.1102051515330.4210-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Feb 2011, Ed Tomlinson wrote:

> Hi,
> 
> My bluetooth usb dongle has stopped working in .38-rc3+
> 
> Bus 002 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
> 
> and in dmesg
> 
> [108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
> [108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
> [108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [108652.971977] usb 5-1: USB disconnect, address 3
> [108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
> [108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
> [108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
> [108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
> [108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
> [108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
> [108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> 
> Its been working for years here.
> 
> Any ideas on what to try or additional info to gather?

Does it still work with earlier kernels or on other computers?

Alan Stern

