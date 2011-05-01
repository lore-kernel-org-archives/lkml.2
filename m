Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293Ab1EARtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:49:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52199 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761273Ab1EARtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:49:07 -0400
Message-ID: <4DBD9D0D.1080503@sieker.io>
Date: Sun, 01 May 2011 19:49:01 +0200
From: "Adi J. Sieker" <adi@core.adi.io>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: USB list <linux-usb@vger.kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
References: <4DBC6FA9.3080008@sieker.io> <201105010953.27052.oliver@neukum.org>
In-Reply-To: <201105010953.27052.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/11 09:53, Oliver Neukum wrote:
> Am Samstag, 30. April 2011, 22:23:05 schrieb Adi J. Sieker:
>> Hello,
>>
>> the lovely folks from #kernelnewbies suggested I write this mail since
>> they are at a loss.
>> I recently got a new USB keyboard which works fine in the BIOS and also
>> in VBox Windows guests, but not on the host.
>>
>> The keyboard is a Keysonic KSK-8003 UX product details here:
>> http://maxpoint.de/de/products/keyboards.php?pid=1_3_7&we_objectID=1220
>>
>> The menu key and the backspace keys do work. The num lock led is on,
>> though I can't switch num lock off.
>> If I attch the keyboard to a VirtualBox VM running WindowsXP as a guest,
>> it works as expected in the VM.
> This indicates that it is working on the USB level.
>
>> I'm running 2.6.32-27-generic #49-Ubuntu. I tried the Ubuntu 10.10
>> LiveCD and that also didn't work. I haven't tried 11.04 yet though.
> Do you get anything on the event device? What does udev say when you
> plug in the device?
>

udevadm monitor output is:
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[1304270944.379238] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3 (usb)
KERNEL[1304270944.380140] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0 (usb)
KERNEL[1304270944.380238] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:060B:0230.0004 
(hid)
KERNEL[1304270944.389434] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input17 
(input)
KERNEL[1304270944.389811] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input17/event7 
(input)
KERNEL[1304270944.389863] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:060B:0230.0004/hidraw/hidraw0 
(hidraw)
KERNEL[1304270944.389917] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1 (usb)
KERNEL[1304270944.390031] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/0003:060B:0230.0005 
(hid)
UDEV  [1304270944.396889] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3 (usb)
UDEV  [1304270944.398067] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1 (usb)
UDEV  [1304270944.398122] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0 (usb)
UDEV  [1304270944.400048] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:060B:0230.0004 
(hid)
UDEV  [1304270944.400947] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:060B:0230.0004/hidraw/hidraw0 
(hidraw)
UDEV  [1304270944.401033] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/0003:060B:0230.0005 
(hid)
UDEV  [1304270944.408614] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input17 
(input)
UDEV  [1304270944.415928] add      
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input17/event7 
(input)

one thing I found out is that this keyboard has some special anti 
ghosting function for some keys. Where you can press multiple keys 
simultaneously
and they are all recognized. This is apparently great for gaming. Which 
I'm not interested in...

Cheers
    Adi


-- 
Adi J. Sieker
Steurentalstr. 2
79252 Stegen
mobile: +49 / 178 / 88 5 88 13
    tel: +49 / 7661 / 91 92 813
    web: http://sieker.io/profile

