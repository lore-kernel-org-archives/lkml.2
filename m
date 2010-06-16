Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab0FPMWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:22:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47196 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab0FPMWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=skVvCy8z4BWGWyneixwC4tlDzrJZNDnBh9w71aoBzOLBBs/wJRO95A1AyBUeV0Tg70
         +DzM1S1wCv++6e4UOPXarB8YtnJp4B1sKCz8WscrjZkTAmWfxnGn9RJ9khPyuetwEeO1
         68jFIydsFXMia1gCu2/tDTqmIreB319eNtcsc=
Message-ID: <4C18C215.7050105@gmail.com>
Date: Wed, 16 Jun 2010 15:22:45 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: INFO: task khubd:271 blocked for more than 120 seconds.
References: <4C18855E.5010508@gmail.com> <201006161030.36000.oneukum@suse.de> <4C188F22.90808@gmail.com> <201006161326.47203.oneukum@suse.de>
In-Reply-To: <201006161326.47203.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
>> Jun 12 17:01:09  kernel: [257610.508638] Uhhuh. NMI received for unknown reason b1.
>> Jun 12 17:01:09  kernel: [257610.508668] You have some hardware problem, likely on the PCI bus.
>> Jun 12 17:01:09  kernel: [257610.508696] Dazed and confused, but trying to continue
> 
> This should definitely not happen. And it now I wonder how functional your
> controller is at that point.

all worked fine until 'Jun 16 00:36:55'. Usb device was used over libusb periodicaly (1-5 minutes) all that time.

>> Jun 12 23:30:30  kernel: [287011.166413] usb 6-1: USB disconnect, address 2
> 
> Still after all this time, this is probably genuine.

I think this was normal usb device plug/unplug.

>> Jun 12 23:30:51  kernel: [287035.906789] usb 6-1: new full speed USB device using uhci_hcd and address 3
>> Jun 12 23:30:51  kernel: [287036.065433] usb 6-1: configuration #1 chosen from 1 choice
>> Jun 12 23:30:51  kernel: [287036.093490] input: HP Virtual Keyboard as /class/input/input7
>> Jun 12 23:30:51  kernel: [287036.168130] input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
>> Jun 12 23:30:51  kernel: [287036.175959] input: HP Virtual Keyboard as /class/input/input8
>> Jun 12 23:30:51  kernel: [287036.216150] input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
>> Jun 12 23:30:51  kernel: [287036.220005] usb 6-1: New USB device found, idVendor=03f0, idProduct=1027
>> Jun 12 23:30:51  kernel: [287036.220005] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> Jun 12 23:30:51  kernel: [287036.220005] usb 6-1: Product: Virtual Keyboard
>> Jun 12 23:30:51  kernel: [287036.220005] usb 6-1: Manufacturer: HP
>> Jun 13 06:25:02  kernel: imklog 3.18.6, log source = /proc/kmsg started.
>> Jun 13 06:25:03  kernel: imklog 3.18.6, log source = /proc/kmsg started.
>> Jun 14 06:25:01  kernel: imklog 3.18.6, log source = /proc/kmsg started.
>> Jun 15 06:25:01  kernel: imklog 3.18.6, log source = /proc/kmsg started.
>> Jun 16 00:36:55  kernel: [600606.885265] usb 6-1: USB disconnect, address 3
> 
> And this. Looks like a bad cable.

I think this is of usb device failure, but the bigest problem is that blocked hang. There isn't any cable except wiretraces on motherboard :D.
That device is like: http://www.aradasystems.com/Upload/ProductImages/128835373116845000image_usb_dongle.jpg and connected dirrectly to
the usb port, which is inside server case.

>> Jun 16 00:39:02  kernel: [600738.152638] INFO: task khubd:271 blocked for more than 120 seconds.
>> Jun 16 00:39:02  kernel: [600738.152682] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Jun 16 00:39:02  kernel: [600738.155993] khubd         D ffff810916ca1400     0   271      2
>> Jun 16 00:39:02  kernel: [600738.156038]  ffff810919523d50 0000000000000046 363030365b3e363c 36323538382e3630
> 
> Alan, didn't you recently fix an issue like this?
> 
> 	Regards
> 		Oliver

