Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab1EAV7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 17:59:16 -0400
Received: from mail.wdtv.com ([66.118.69.84]:40008 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1EAV7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 17:59:14 -0400
From: gene heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Nother silly Q
Date: Sun, 1 May 2011 17:59:03 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-pclos1.pae; KDE/4.6.2; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105011759.03189.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Apparently, as of 2.6.38.4, sane and xsane are dead, cannot find any 
devices.

>From dmesg: an Epson NX515 MFP which includes a scanner
usb 1-4: new high speed USB device using ehci_hcd and address 4
usb 1-4: New USB device found, idVendor=04b8, idProduct=0856
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: USB2.0 MFP(Hi-Speed)
usb 1-4: Manufacturer: EPSON
usb 1-4: SerialNumber: 4C454C593037313524
usb 1-4: usbfs: interface 2 claimed by usb-storage while 'usb' sets config 
#1

And from dmesg: an Epson 1250-u flatbed scanner:
usb 2-7: new full speed USB device using ohci_hcd and address 4
usb 2-7: New USB device found, idVendor=04b8, idProduct=010f
usb 2-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-7: Product: EPSON Scanner 010F
usb 2-7: Manufacturer: EPSON

lspci & lsusb outputs look ok.  As recently as 2.6.38 final, xsane was 
showing me a menu that included these 2 scanners plus my pcHDTV-3000 card 
as possible src's.

What do I need to do to fix this?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<http://tinyurl.com/ddg5bz>
<http://www.cantrip.org/gatto.html>
General notions are generally wrong.
		-- Lady M.W. Montagu
