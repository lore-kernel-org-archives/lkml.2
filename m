Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab2IRXW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:22:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56190 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2IRXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:22:23 -0400
Date: Tue, 18 Sep 2012 20:22:11 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: acho@suse.com
Cc: marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        oneukum@suse.com, jlee@suse.com, resler@cs.cas.cz
Subject: Re: [PATCH] Bluetooth: Add support for BCM20702A0 [04ca, 2003]
Message-ID: <20120918232211.GC24689@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>, acho@suse.com,
	marcel@holtmann.org, johan.hedberg@gmail.com,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	oneukum@suse.com, jlee@suse.com, resler@cs.cas.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In-Reply-To: <1347355532-9185-1-git-send-email-acho@suse.com>

* acho@suse.com <acho@suse.com> [2012-09-11 17:25:32 +0800]:

> From: Jaroslav Resler <resler@cs.cas.cz>
> 
> Add another vendor specific ID for BCM20702A0.
> 
> output of usb-devices:
> T:  Bus=01 Lev=02 Prnt=02 Port=03 Cnt=02 Dev#=  4 Spd=12   MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=04ca ProdID=2003 Rev= 1.12
> S:  Manufacturer=Broadcom Corp
> S:  Product=BCM20702A0
> S:  SerialNumber=446D57861623
> C:* #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=84(I) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> Signed-off-by: Cho, Yu-Chen <acho@suse.com>
> ---
>  drivers/bluetooth/btusb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
