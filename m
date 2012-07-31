Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2GaQPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:15:08 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51151 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2GaQPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:15:05 -0400
Message-ID: <1343751179.1803.73.camel@aeonflux>
Subject: Re: Unable to Detect Bluetooth Device on Macbook Pro 9,2 (Mid-2012
 13")
From: Marcel Holtmann <marcel@holtmann.org>
To: Shea Levy <shea@shealevy.com>
Cc: linux-bluetooth@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 31 Jul 2012 09:12:59 -0700
In-Reply-To: <50180209.1090002@shealevy.com>
References: <5017E234.2000207@shealevy.com>
	 <1343749923.1803.68.camel@aeonflux> <50180209.1090002@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shea,

> > include /sys/kernel/debug/usb/devices details for this device.
> 
> Not sure, which device it is, so here's all of bus 4:

<snip>

> T:  Bus=04 Lev=04 Prnt=04 Port=02 Cnt=03 Dev#=  9 Spd=12   MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=05ac ProdID=821d Rev= 0.86
> S:  Manufacturer=Apple Inc.
> S:  Product=Bluetooth USB Host Controller
> C:* #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=84(I) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

lets take the one that says Bluetooth USB Host Controller ;)

Regards

Marcel


