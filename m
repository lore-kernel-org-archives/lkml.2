Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1BPOBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:01:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46067 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab1BPOBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:01:02 -0500
Date: Wed, 16 Feb 2011 11:00:53 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] usb problems in .38-rc3+
Message-ID: <20110216140053.GE14085@joana>
References: <201102051417.58953.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102051417.58953.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ed,

* Ed Tomlinson <edt@aei.ca> [2011-02-05 14:17:57 -0500]:

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

What's the symptom? what do you mean by stopped to work?

Can you provide me output of "hciconfig -a"?

And if possible enable dynamic debug for your kernel, mount the debugfs 
and then

echo -n "module btusb +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "module bluetooth +p" > /sys/kernel/debug/dynamic_debug/control

-- 
Gustavo F. Padovan
http://profusion.mobi
