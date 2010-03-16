Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965977Ab0CPCJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:09:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51712
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965957Ab0CPCJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:09:14 -0400
Date: Mon, 15 Mar 2010 19:09:36 -0700 (PDT)
Message-Id: <20100315.190936.56187308.davem@davemloft.net>
To: keil@b1-systems.de
Cc: torvalds@linux-foundation.org, lars.ellenberg@linbit.com,
       netdev@vger.kernel.org, andreas@eversberg.eu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ISDN: Add PCI ID for HFC-2S/4S Beronet Card PCIe
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268702879.31146@pingi>
References: <1268668176.12629@pingi>
	<1268702879.31146@pingi>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <keil@b1-systems.de>
Date: Mon, 15 Mar 2010 14:18:41 +0100

> From: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> A few subdevice IDs seem to have been dropped when hfc_multi was
> included upstream, just compare the list at
> http://www.openvox.cn/viewvc/misdn/trunk/hfc_multi.c?revision=75&view=annotate#l175
> with the IDs in drivers/isdn/hardware/mISDN/hfcmulti.c
> 
> Added PCIe 2 Port card and LED settings (same as PCI)
> Do not use <linux/pci_ids.h> /KKe
> 
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Karsten Keil <keil@b1-systems.de>

Applied, thanks.
