Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0IGGPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:15:13 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:49425 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0IGGPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:15:04 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Regarding USB-serial device driver
Date: Tue, 7 Sep 2010 11:44:50 +0530
Message-Id: <20100907061327.M12473@admin-gateway.ncra.tifr.res.in>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Greg,
               I have a UART device  driver which is used to control some  MCM ( Monitor
& control module ) devices with  address like 2,3,5,10,14 & 0 thru serial port using
RS-485 interface card.

Now I want to control these devices thru usb-serial adaptor card.When I plug the
usb-to-serial device.It's shows me the terminal ttyUSB0.

I tried sending data thru it , but in between some junk data is also going out ....

output of usbmon :

 ee26be80 3612838323 S Co:7:002:0 s 40 01 0008 0000 0000 0
ee26be80 3612839660 C Co:7:002:0 0 0
ee26be80 3612839716 S Co:7:002:0 s 40 01 0009 0000 0000 0
ee26be80 3612840660 C Co:7:002:0 0 0
ee26be80 3612840700 S Ci:7:002:0 s a1 21 0000 0000 0007 7 <
ee26be80 3612841661 C Ci:7:002:0 0 7 = 80250000 000008
ee26be80 3612841710 S Co:7:002:0 s 21 20 0000 0000 0007 7 = 80250000 000008
ee26be80 3612842659 C Co:7:002:0 0 7 >
ee26be80 3612842672 S Co:7:002:0 s 21 22 0003 0000 0000 0
ee26be80 3612843657 C Co:7:002:0 0 0
ee2b3800 3612843712 S Ci:7:002:0 s a1 21 0000 0000 0007 7 <
ee2b3800 3612844658 C Ci:7:002:0 0 7 = 80250000 000008
ee2b3800 3612844668 S Co:7:002:0 s 40 01 0000 0000 0000 0
ee2b3800 3612845660 C Co:7:002:0 0 0
ee0eaf80 3612845669 S Bi:7:002:3 -115 256 <
ee0ead00 3612845674 S Ii:7:002:1 -115:1 10 <
ee2b3800 3612845679 S Co:7:002:0 s 21 22 0003 0000 0000 0
ee2b3800 3612846657 C Co:7:002:0 0 0
ee0ea680 3618022849 S Bo:7:002:2 -115 100 = 00080000 00000000 f8000000 00000000 00000000
00000000 00000000 00000000
ee0ea680 3618024532 C Bo:7:002:2 0 100 >


Ideally data which should go out is : 0080000000f8.( device address is 0 and check sum
is f8 ).

In my  previous emails, you told me to use current kernel version..so I am now using
2.6.35 kernel version.

 kindly help me.


Thanks-
 Raj.
--
Open WebMail Project (http://openwebmail.org)

