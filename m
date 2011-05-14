Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab1ENAuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 20:50:51 -0400
Received: from v021818.home.net.pl ([89.161.133.228]:62281 "HELO
	v021818.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758522Ab1ENAut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 20:50:49 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 May 2011 20:50:48 EDT
Message-ID: <BAD23DF0CF2645B1A237F4CA7D0B6C70@int.nthmedia.pl>
From: =?UTF-8?Q?Marcin_Ga=C5=82czy=C5=84ski?= <marcin@galczynski.pl>
To: <linux-kernel@vger.kernel.org>
Subject: USB driver "option" proposed patch to support Huawei E353 hardware
Date: Sat, 14 May 2011 02:44:10 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0047_01CC11E0.CD60C740"
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 15.4.3508.1109
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3508.1109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To jest wieloczjciowa wiadomof w formacie MIME.

------=_NextPart_000_0047_01CC11E0.CD60C740
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 8bit

Hi,

I am sharing patch to the devices/usb/serial/option.c. This allows operation 
of Huawei E353 broadband modem using the “option” driver. The patch simply 
adds new constant with proper product ID and an entry to usb_device_id. I 
worked on the fresh driver file downloaded from GIT. Tested on Dell inspiron 
1764 (i3 core cpu) and brand new Huawei E353 modem, Fedora 15 beta.

Looking at the type of change, i doubt it has potential to introduce 
problems in other parts of kernel or the driver itself.

I am not an active kernel developer, thus i would not be joining the list... 
for now. If You’d like to reach me, please respond directly.


--best rgds
Marcin Galczynski 

------=_NextPart_000_0047_01CC11E0.CD60C740
Content-Type: application/octet-stream;
	name="devices-usb-serial-option.c-enable-huaweiE353.path"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="devices-usb-serial-option.c-enable-huaweiE353.path"

*** option.c.old	2011-05-14 02:11:00.174063786 +0200=0A=
--- option.c	2011-05-14 02:03:34.312602150 +0200=0A=
***************=0A=
*** 149,154 ****=0A=
--- 149,155 ----=0A=
  #define HUAWEI_PRODUCT_K3765			0x1465=0A=
  #define HUAWEI_PRODUCT_E14AC			0x14AC=0A=
  #define HUAWEI_PRODUCT_ETS1220			0x1803=0A=
+ #define HUAWEI_PRODUCT_E353			0x1506=0A=
  =0A=
  #define QUANTA_VENDOR_ID			0x0408=0A=
  #define QUANTA_PRODUCT_Q101			0xEA02=0A=
***************=0A=
*** 532,537 ****=0A=
--- 533,539 ----=0A=
  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, =
HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff) },=0A=
  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, =
HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },=0A=
  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, =
HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },=0A=
+ 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, =
HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x01) },=0A=
  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) =
},=0A=
  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) =
},=0A=
  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V740) =
},=0A=

------=_NextPart_000_0047_01CC11E0.CD60C740--

