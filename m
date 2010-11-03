Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab0KCTHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:07:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49575 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0KCTHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=jSV96VA7a5ivvrwnuonbBIzg/CgfpKDgZG3yH4Qq/VZf8556Ly5dcZndmqTCHZuRKm
         39JmeNIcg7n34O6j55pa7me4ZB4FwoPc+hdPSp7+YNdmbjIkJzJX8I4xKt9x5phUHusI
         +qhojik+5oINuhorw81lL546sIw4ZTw7eFG+g=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: =?utf-8?q?T=C3=B5nu_Samuel?= <tonu@jes.ee>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: gspca for_2.6.36 - maybe does not work properly for me
Date: Wed, 3 Nov 2010 20:07:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1288264077.1891.40.camel@x41.itrotid.ee>
In-Reply-To: <1288264077.1891.40.camel@x41.itrotid.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011032007.25474.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add CC's)
On czwartek, 28 października 2010 o 13:07:57 Tõnu Samuel wrote:
> I am Sony PS3 Eye webcam user.
> 
> After installing 2.6.36 this camera gets recognized but actually does
> not work. It might be some own stupidity of improper kernel
> configuration but I cannot track it down at moment.
> 
> relevant dmesg:
> 
> [ 1372.224068] usb 1-5: new high speed USB device using ehci_hcd and
> address 5
> [ 1372.359574] usb 1-5: New USB device found, idVendor=1415,
> idProduct=2000
> [ 1372.359582] usb 1-5: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [ 1372.359588] usb 1-5: Product: USB Camera-B4.04.27.1
> [ 1372.359593] usb 1-5: Manufacturer: OmniVision Technologies, Inc.
> [ 1372.360623] gspca: probing 1415:2000
> [ 1372.483830] ov534: Sensor ID: 7721
> [ 1372.534205] ov534: frame_rate: 30
> [ 1372.534319] gspca: video0 created
> 
> spider@spider:~$ lsusb -t
> /:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/2p, 12M
> /:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/3p, 12M
> 
>     |__ Port 2: Dev 2, If 0, Class='bInterfaceClass 0xe0 not yet
> 
> handled', Driver=btusb, 12M
> 
>     |__ Port 2: Dev 2, If 1, Class='bInterfaceClass 0xe0 not yet
> 
> handled', Driver=btusb, 12M
> /:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/3p, 12M
> /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/3p, 12M
> /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/3p, 12M
> 
>     |__ Port 1: Dev 2, If 0, Class=HID, Driver=usbhid, 1.5M
>     |__ Port 1: Dev 2, If 1, Class=HID, Driver=usbhid, 1.5M
> 
> /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
> 
>     |__ Port 3: Dev 2, If 0, Class=vend., Driver=rt2870, 480M
> 
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
> 
>     |__ Port 5: Dev 5, If 0, Class=vend., Driver=ov534, 480M
>     |__ Port 5: Dev 5, If 1, Class=audio, Driver=snd-usb-audio, 480M
>     |__ Port 5: Dev 5, If 2, Class=audio, Driver=snd-usb-audio, 480M
> 
> spider@spider:~$
> 
> spider@spider:~$ guvcview
> guvcview 1.1.3
> video device: /dev/video0
> /dev/video0 - device 1
> Init. USB Camera-B4.04.27.1 (location: usb-0000:00:12.2-5)
> { pixelformat = 'YUYV', description = 'YUYV' }
> { discrete: width = 320, height = 240 }
> 	Time interval between frame: 1/125, 1/100, 1/75, 1/60, 1/50, 1/40,
> 1/30,
> { discrete: width = 640, height = 480 }
> 	Time interval between frame: 1/60, 1/50, 1/40, 1/30, 1/15,
> checking format: 1448695129
> vid:1415
> pid:2000
> driver:ov534
> VIDIOC_STREAMON - Unable to start capture: Device or resource busy
> 
> 
> 
> No image is produced with any webcam software I have tried.
> 
> Kernel config is too big to be posted here, so I skip it.
> 
> I have tried same on different computers with Intel integrated video and
> NVIDIA propietary stuff to ensure I have all right with video side.
> BTW new PS3 Eye (looks same but product code is different, price is
> lower) is released in Japan and I get my hands on it today later. Then I
> check if old driver works at all etc.
> 

2.6.35,  or  another, older kernel works OK?
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
