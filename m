Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2GJTne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:43:34 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51326 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2GJTnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:43:33 -0400
Date: Tue, 10 Jul 2012 16:43:25 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: manoj.iyer@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: btusb: Add vendor specific ID (0a5c:21f4)
 BCM20702A0
Message-ID: <20120710194325.GA31426@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	manoj.iyer@canonical.com, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <1341947258-3929-1-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341947258-3929-1-git-send-email-manoj.iyer@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

* manoj.iyer@canonical.com <manoj.iyer@canonical.com> [2012-07-10 14:07:38 -0500]:

> From: Manoj Iyer <manoj.iyer@canonical.com>
> 
> Patch adds support for BCM20702A0 device id (0a5c:21f4).
> 
> usb-devices after patch was applied:
> T: Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 2 Spd=12 MxCh= 0
> D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P: Vendor=0a5c ProdID=21f4 Rev=01.12
> S: Manufacturer=Broadcom Corp
> S: Product=BCM20702A0
> S: SerialNumber=E4D53DF154D6
> C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> usb-devices before patch was applied:
> T: Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 2 Spd=12 MxCh= 0
> D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P: Vendor=0a5c ProdID=21f4 Rev=01.12
> S: Manufacturer=Broadcom Corp
> S: Product=BCM20702A0
> S: SerialNumber=E4D53DF154D6
> C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> Tested-by: Chris Gagnon <chris.gagnon@canonical.com>
> ---
>  drivers/bluetooth/btusb.c |    1 +
>  1 file changed, 1 insertion(+)

Patch has been applied to the bluetooth tree. Thanks.

	Gustavo
