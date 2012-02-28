Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2B1Pag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:30:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41197 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755542Ab2B1Paf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:30:35 -0500
Date: Tue, 28 Feb 2012 10:30:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Meng Zhang <meng.zhang@mediatek.com>
cc: Josua Dietze <digidietze@draisberghof.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Phil Dibowitz <phil@ipom.com>, USB list <linux-usb@vger.kernel.org>,
        USB Storage list <usb-storage@lists.one-eyed-alien.net>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
In-Reply-To: <4F4C998D.4000805@mediatek.com>
Message-ID: <Pine.LNX.4.44L0.1202281028350.1456-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012, Meng Zhang wrote:

> from: Meng Zhang <meng.zhang@mediatek.com>
> 
> 1. Add entrys for mediatek MT6276M in unusual_devs.h
> 
> 2. Add init function for mediatek MT6276M to switch to COM port mode
> 
> 3. usb-devices outputs after running with this patch:
> T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#= 48 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=0e8d ProdID=00a1 Rev=02.00
> S:  Manufacturer=MediaTek Inc
> S:  Product=Product
> C:  #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=500mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=02 Prot=01 Driver=option
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> 
> 4. patch based on branch:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> 
> Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>

Nowadays, aren't such things handled in userspace by the usb_modeswitch 
program rather than in the kernel driver?

Alan Stern

