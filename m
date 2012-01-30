Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2A3WDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:03:51 -0500
Received: from senator.holtmann.net ([87.106.208.187]:42898 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2A3WDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:03:50 -0500
Message-ID: <1327960915.1955.184.camel@aeonflux>
Subject: Re: [PATCH] Bluetooth: Add support for BCM20702A0 [0a5c:21e6]
From: Marcel Holtmann <marcel@holtmann.org>
To: "James M. Leddy" <james.leddy@canonical.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Jan 2012 14:01:55 -0800
In-Reply-To: <1327698606-12503-1-git-send-email-james.leddy@canonical.com>
References: <1327698606-12503-1-git-send-email-james.leddy@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

> Add another vendor specific ID for BCM20702A0. This has 
> been tested and works on hardware with this device.
> 
> output of usb-devices:
> T: Bus=01 Lev=02 Prnt=02 Port=03 Cnt=04 Dev#= 6 Spd=12 MxCh= 0
> D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P: Vendor=0a5c ProdID=21e6 Rev=01.12
> S: Manufacturer=Broadcom Corp
> S: Product=BCM20702A0
> S: SerialNumber=D0DF9AFB227B
> C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> Signed-off-by: James M. Leddy <james.leddy@canonical.com>
> ---
>  drivers/bluetooth/btusb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


