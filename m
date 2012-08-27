Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2H0PRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:17:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43390 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2H0PRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:17:00 -0400
Date: Mon, 27 Aug 2012 08:16:47 -0700
From: Gustavo Padovan <gustavo@padovan.org>
To: Shea Levy <shea@shealevy.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH RESEND] Bluetooth: Add support for Apple MacBook Pro 9,2
Message-ID: <20120827151647.GB8934@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Shea Levy <shea@shealevy.com>, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>
References: <1344374463-21231-1-git-send-email-shea@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344374463-21231-1-git-send-email-shea@shealevy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shea,

* Shea Levy <shea@shealevy.com> [2012-08-07 17:21:03 -0400]:

> $ usb-devices
> <snip>
> T:  Bus=04 Lev=04 Prnt=04 Port=02 Cnt=01 Dev#=  9 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=05ac ProdID=821d Rev=00.86
> S:  Manufacturer=Apple Inc.
> S:  Product=Bluetooth USB Host Controller
> C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> <snip>
> 
> Signed-off-by: Shea Levy <shea@shealevy.com>
> ---
>  drivers/bluetooth/btusb.c | 3 +++
>  1 file changed, 3 insertions(+)

So this is outdated by the USB_VENDOR_AND_INTERFACE_INFO() patch that I just
applied.

	Gustavo
