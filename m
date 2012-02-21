Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2BUTHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:07:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46458 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2BUTG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:06:59 -0500
Date: Tue, 21 Feb 2012 17:06:54 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bluetooth: Add AR30XX device ID on Asus laptops
Message-ID: <20120221190654.GB2914@joana>
Mail-Followup-To: Keng-Yu Lin <kengyu@canonical.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1321422409.15441.510.camel@aeonflux>
 <1322649157-20479-1-git-send-email-kengyu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322649157-20479-1-git-send-email-kengyu@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keng,

* Keng-Yu Lin <kengyu@canonical.com> [2011-11-30 18:32:37 +0800]:

> The ID is found on Asus K54HR and K53U.
> Blacklist the AR3011-based device ID [0489:e03d]
> and add to ath3k.c for firmware loading.
> 
> Below is the output of usb-devices script:
> 
> Before the fiwmware loading:
> 
> T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0489 ProdID=e03d Rev=00.01
> C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> 
> After the fiwmware loading:
> 
> T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  5 Spd=12  MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0cf3 ProdID=3005 Rev=00.01
> C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> 
> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
> ---
>  drivers/bluetooth/ath3k.c |    1 +
>  drivers/bluetooth/btusb.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)

Applied, thanks.

	Gustavo
