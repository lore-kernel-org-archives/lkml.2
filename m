Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0KCTOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:14:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59254 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0KCTOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:14:18 -0400
Date: Wed, 3 Nov 2010 15:14:29 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: gimli <gimli@dark-green.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] MacBookAir3,1(3,2) btusb support
Message-ID: <20101103191429.GA21114@vigoh>
References: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com>
 <20101102152454.GC11778@core.coreip.homeip.net>
 <1288712282.3322.181.camel@aeonflux>
 <20101103182159.GA17943@vigoh>
 <4CD1B30C.6010904@dark-green.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD1B30C.6010904@dark-green.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gimli,

We don't allow top posting in this mailing, please keep that in mind
next time. Thanks.

* gimli <gimli@dark-green.com> [2010-11-03 20:07:56 +0100]:

> Hi,
> 
> in what form i should provide it ?


This is a example:

commit 3cd01976e702ccaffb907727caff4f8789353599
Author: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date:   Fri Aug 20 16:24:07 2010 +0900

    Bluetooth: Add support Bluetooth controller of MacbookPro 7,1
    
    Bluetooth controller of MacbookPro 7,1 does not work.
    Because Device Class of these controllers was set 255 (Vendor Sepecific Class).
    
    T:  Bus=04 Lev=02 Prnt=04 Port=00 Cnt=01 Dev#=  5 Spd=12  MxCh= 0
    D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
    P:  Vendor=05ac ProdID=8213 Rev=01.86
    S:  Manufacturer=Apple Inc.
    S:  Product=Bluetooth USB Host Controller
    S:  SerialNumber=5C5948C81B99
    C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
    I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
    I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
    I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
    I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=00 Driver=(none)
    
    Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    Acked-by: Marcel Holtmann <marcel@holtmann.org>
    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
