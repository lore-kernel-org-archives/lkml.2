Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937310Ab0CPBJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:09:01 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:45998 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937290Ab0CPBI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:08:59 -0400
From: Karsten Keil <keil@b1-systems.de>
Organization: B1 Systems GmbH
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ISDN: Add PCI ID for HFC-2S/4S Beronet Card PCIe
Date: Tue, 16 Mar 2010 02:08:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.42-0.1-default; KDE/4.4.1; x86_64; ; )
Cc: torvalds@linux-foundation.org, lars.ellenberg@linbit.com,
       netdev@vger.kernel.org, andreas@eversberg.eu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1268668176.12629@pingi> <20100315.160133.67908104.davem@davemloft.net>
In-Reply-To: <20100315.160133.67908104.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003160208.57232.keil@b1-systems.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 16. März 2010 00:01:33 David Miller wrote:
> From: Karsten Keil <keil@b1-systems.de>
> Date: Mon, 15 Mar 2010 14:18:41 +0100
> 
> > A few subdevice IDs seem to have been dropped when hfc_multi was
> > included upstream, just compare the list at
> > http://www.openvox.cn/viewvc/misdn/trunk/hfc_multi.c?revision=75&view=ann
> >otate#l175 with the IDs in drivers/isdn/hardware/mISDN/hfcmulti.c
> >
> > Added PCIe 2 Port card and LED settings (same as PCI) /KKe
> >
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > Signed-off-by: Karsten Keil <keil@b1-systems.de>
> 
> We don't add new defines to linux/pci_ids.h, it is deprecated.
> Simply add the device ID constants to the table.

Good policy, makes sense. Will send a new version.
May a check for adding  defines to  <linux/pci_ids> would help to enforce it.

> 
> The only exception is the case where a device ID is used in
> more than one driver, but even that scenerio is heavily
> discouraged.
> 

Is here some plan to cleanup drivers for -next and remove IDs from pci_ids.h,
or should it not changed for old  entries ?

Karsten
