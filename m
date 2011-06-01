Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1FAHFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:05:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50773 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1FAHFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IhxpqkYFMyRiJR+Yz/9RQSiA3mhxUVWeLelhsRScoYSybZhQIJIYfgNAUHmKESFt23
         paeIFaYx5mV2+TYG8B54ahyYKBzjjuek9AIpRCoGvxdVkqVM5FTDFVAto3kVLidTVsDb
         12EWdGDSX2r/E4wXJ5yPDcq+EdAibIchbtKD8=
Message-ID: <4DE5E4C8.5060706@gmail.com>
Date: Wed, 01 Jun 2011 09:05:44 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
References: <4DE25252.7050503@gmail.com> <4DE36118.4050706@gmail.com> <4DE3F0E6.6030507@gmail.com> <201105311037.46856.oneukum@suse.de>
In-Reply-To: <201105311037.46856.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/05/2011 10:37, Oliver Neukum ha scritto:
> Am Montag, 30. Mai 2011, 21:32:54 schrieb Riccardo Magliocchetti:
>>>> So we are trying to talk to a device that is already gone.
>>>> Is there anything unusual about your device? Could you
>>>> post "lsusb -v"?
>>>
>>> Yes, the unusual thing is that is very prone to freezing when booting,
>>> in fact it freezed when i got the crash in the laptop. Will post lsusb
>>> output later in the day.
>>
>> Here's the lsusb -v
>
> There is something strange going on. This is a cdc-ether device.
> Are you using any additional patches?

I'm using a vanilla 2.6.39. I can get only lsusb when the phone is 
booted and in that case it is recgnized as cdc-ether.

This is what i got when i attached the phone switched off like when i 
got the crash:

usb 6-1: new full speed USB device number 3 using uhci_hcd
usb 6-1: New USB device found, idVendor=1d50, idProduct=5119
usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 6-1: Product: Neo1973 Bootloader U-Boot 1.3.2-dirty-moko12
usb 6-1: Manufacturer: OpenMoko, Inc
usb 6-1: SerialNumber: 0000000
cdc_acm 6-1:1.0: This device cannot do calls on its own. It is not a modem.
cdc_acm 6-1:1.0: ttyACM0: USB ACM device
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN 
adapters
hub 6-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
usb 6-1: USB disconnect, device number 3
usb 6-1: new full speed USB device number 4 using uhci_hcd
usb 6-1: device descriptor read/64, error -71
usb 6-1: device descriptor read/64, error -71
usb 6-1: new low speed USB device number 5 using uhci_hcd
usb 6-1: device descriptor read/64, error -71
usb 6-1: new full speed USB device number 6 using uhci_hcd
usb 6-1: device not accepting address 6, error -71
usb 6-1: new full speed USB device number 7 using uhci_hcd
usb 6-1: device not accepting address 7, error -71
hub 6-0:1.0: unable to enumerate USB device on port 1

thanks,
riccardo
