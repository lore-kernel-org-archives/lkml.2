Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0KCUT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:19:59 -0400
Received: from mognix.dark-green.com ([88.116.226.179]:57664 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0KCUTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:19:54 -0400
Message-ID: <4CD1C3E5.3030507@dark-green.com>
Date: Wed, 03 Nov 2010 21:19:49 +0100
From: gimli <gimli@dark-green.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: Marcel Holtmann <marcel@holtmann.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] MacBookAir3,1(3,2) btusb support
References: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com> <20101102152454.GC11778@core.coreip.homeip.net> <1288712282.3322.181.camel@aeonflux> <20101103182159.GA17943@vigoh> <4CD1B30C.6010904@dark-green.com> <20101103191429.GA21114@vigoh>
In-Reply-To: <20101103191429.GA21114@vigoh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the output :

T:  Bus=03 Lev=02 Prnt=03 Port=02 Cnt=01 Dev#=  6 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=05ac ProdID=821b Rev= 0.34
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
C:* #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  32 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  32 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  64 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  64 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  64 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  64 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=84(I) Atr=02(Bulk) MxPS=  32 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  32 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)


Am 03.11.10 20:14, schrieb Gustavo F. Padovan:
> Hi Gimli,
>
> We don't allow top posting in this mailing, please keep that in mind
> next time. Thanks.
>
> * gimli<gimli@dark-green.com>  [2010-11-03 20:07:56 +0100]:
>
>> Hi,
>>
>> in what form i should provide it ?
>
>
> This is a example:
>
> commit 3cd01976e702ccaffb907727caff4f8789353599
> Author: Nobuhiro Iwamatsu<iwamatsu@nigauri.org>
> Date:   Fri Aug 20 16:24:07 2010 +0900
>
>      Bluetooth: Add support Bluetooth controller of MacbookPro 7,1
>
>      Bluetooth controller of MacbookPro 7,1 does not work.
>      Because Device Class of these controllers was set 255 (Vendor Sepecific Class).
>
>      T:  Bus=04 Lev=02 Prnt=04 Port=00 Cnt=01 Dev#=  5 Spd=12  MxCh= 0
>      D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
>      P:  Vendor=05ac ProdID=8213 Rev=01.86
>      S:  Manufacturer=Apple Inc.
>      S:  Product=Bluetooth USB Host Controller
>      S:  SerialNumber=5C5948C81B99
>      C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
>      I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
>      I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>      I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
>      I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=00 Driver=(none)
>
>      Signed-off-by: Nobuhiro Iwamatsu<iwamatsu@nigauri.org>
>      Acked-by: Marcel Holtmann<marcel@holtmann.org>
>      Signed-off-by: Gustavo F. Padovan<padovan@profusion.mobi>
>

