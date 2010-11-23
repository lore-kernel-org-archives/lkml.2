Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0KWUv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:51:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64762 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0KWUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:subject:content-type:content-transfer-encoding;
        b=ees14uZ3AbSPf3rTZRmYMiX/tpx4X2KwHbV7seh4zRDZJGTJCFqEKCOKY6/pgajOx4
         KWbxyk5x5zVEqoLbfpMmKX85EluVB6lY1q9zd2dZ5YBLxAsf96K9PdJALLiH2WsA+vo6
         G3jBIS4a5i0UjB2Y5NFzeFSN33HD+I6mXmXrs=
Message-ID: <4CEC294A.5080706@gmail.com>
Date: Tue, 23 Nov 2010 21:51:22 +0100
From: Julien lengrand-lambert <jlengrand@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux comptability with a KSK-6001 Keysonic Keyboard
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found your mail while searching for help in the Linux usb device 
community.
  If this is the wrong way to ask, feel free to mail me back with the 
good way so that I can correct it :)

I just bought a KSK-6001 UELX keyboard with my new computer.
You may find more information here :
http://www.maxpoint.de/de/products/keyboards.php?pid=1_3_7&we_objectID=1219

I have an issue running on my Ubuntu Linux. The keyboard is detected 
during the grub start, which I think is ruled by the bios driver.
But it is totally impossible for me to use it as soon as the splash screen.

The keyboard is detected, as a lsusb prompt me :
Bus 003 Device 004: ID 060b:2231 Solid Year

However, when I look at the dmesg, I get the following error :
[  171.544035] usb 3-2: new low speed USB device using ohci_hcd and 
address 4
[  171.725207] usb 3-2: configuration #1 chosen from 1 choice
[  171.738509] input: KB USB Keyboard as 
/devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input6
[  171.738669] generic-usb 0003:060B:2231.0005: input,hidraw1: USB HID 
v1.10 Keyboard [KB USB Keyboard] on usb-0000:00:12.0-2/input0
[  171.754316] generic-usb: probe of 0003:060B:2231.0006 failed with 
error -22

Seems like the keyboard is detected during start up; and it is well 
detected as a keyboard interface. It is however impossible for him to be 
driven by my OS.

I must add that I tested the keyboard on 4 different computers, with 
various versions of Ubuntu Linux (from 10.04 to 10.10) and even with the 
last 2.6.37 kernel.

I did not find any relevant information about it on the internet, and 
the -22 error seems very rare :s

Perhaps could you help me to solve this issue? I am ready to give you 
any new information you may need.
I would be really grateful to have some help, as I am already struggling 
for two weeks to make it work.

Best regards,
Julien Lengrand-Lambert
