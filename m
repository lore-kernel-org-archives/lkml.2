Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0KCVu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:50:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38573 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0KCVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:50:55 -0400
Date: Wed, 3 Nov 2010 17:51:06 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: gimli <gimli@dark-green.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] MacBookAir3,1(3,2) btusb support
Message-ID: <20101103215106.GA21950@vigoh>
References: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com>
 <20101102152454.GC11778@core.coreip.homeip.net>
 <1288712282.3322.181.camel@aeonflux>
 <20101103182159.GA17943@vigoh>
 <4CD1B30C.6010904@dark-green.com>
 <20101103191429.GA21114@vigoh>
 <4CD1C3E5.3030507@dark-green.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD1C3E5.3030507@dark-green.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gimli,

Again, please stop top posting, it's not accepted here.

* gimli <gimli@dark-green.com> [2010-11-03 21:19:49 +0100]:

> Here is the output :
> 
> T:  Bus=03 Lev=02 Prnt=03 Port=02 Cnt=01 Dev#=  6 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=05ac ProdID=821b Rev= 0.34
> S:  Manufacturer=Apple Inc.
> S:  Product=Bluetooth USB Host Controller
> C:* #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  32 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  32 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  64 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  64 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  64 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  64 Ivl=1ms
> I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=84(I) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Actually you have to post the output of usb-devices without your patch
to show why your patch need is needed. And you should add that to the
commit message and resend your patch to linux-bluetooth instead of
posting it on this thread.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
