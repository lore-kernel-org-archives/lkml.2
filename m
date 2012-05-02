Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2EBV3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:29:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49028 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2EBV3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:29:32 -0400
Date: Wed, 2 May 2012 18:28:55 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Michael =?iso-8859-1?Q?Gr=FCtzner?= <mgruetzn@gmx.de>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bluetooth: Add support for Foxconn/Hon Hai AR5BBU22
 0489:E03C
Message-ID: <20120502212855.GC16030@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Michael =?iso-8859-1?Q?Gr=FCtzner?= <mgruetzn@gmx.de>,
	marcel@holtmann.org, johan.hedberg@gmail.com,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1769868.QZY8sEHkp9@dagobah>
 <20120502150844.GB16030@joana>
 <5301735.uaK8kx1qmQ@dagobah>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5301735.uaK8kx1qmQ@dagobah>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

* Michael Grützner <mgruetzn@gmx.de> [2012-05-02 22:33:40 +0200]:

> From: Michael Gruetzner <mgruetzn@gmx.de>
> 
> Add Foxconn/Hon Hai AR5BBU22 Bluetooth Module( 0x489:0xE03C) to
> the blacklist of btusb module and add it to the ath3k module to properly
> load the firmware in Kernel 3.3.4
> The device is integrated in  e.g. some  Acer Aspire 7750G.
> 
> Output from /sys/kernel/debug/usb/devices:
> 
> T:  Bus=01 Lev=02 Prnt=02 Port=05 Cnt=02 Dev#=  6 Spd=12   MxCh= 0
> D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0489 ProdID=e03c Rev= 0.02
> S:  Manufacturer=Atheros Communications
> S:  Product=Bluetooth USB Host Controller
> S:  SerialNumber=Alaska Day 2006
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
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
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>  
> Signed-off-by: Michael Gruetzner <mgruetzn@gmx.de>
> ---
>  drivers/bluetooth/ath3k.c |    6 ++++++
>  drivers/bluetooth/btusb.c |    3 +++
>  2 files changed, 9 insertions(+)

Patch has been applied to both bluetooth and bluetooth-next trees.
Thanks.

	Gustavo
