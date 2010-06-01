Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0FAWcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:32:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52124
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260Ab0FAWb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:31:59 -0400
Date: Tue, 01 Jun 2010 15:32:09 -0700 (PDT)
Message-Id: <20100601.153209.135521213.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: netdev@vger.kernel.org, mcarlson@broadcom.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [2.6.35-rc1 regression] tg3 vpd r/w failed
From: David Miller <davem@davemloft.net>
In-Reply-To: <19461.26529.591960.912204@pilspetsen.it.uu.se>
References: <19461.26529.591960.912204@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mikael I'm getting tired of continuing to add the proper
mailing list CC: for your sparc bug reports.  Please make
sure to add sparclinux@vger.kernel.org to your reports
in the future.

Thanks.

> Booting 2.6.35-rc1 on a Sun Blade 2500 Red with builtin tg3 I get:
> 
> tg3.c:v3.110 (April 9, 2010)
> PCI: Enabling device: (0000:00:03.0), cmd 2
> ...
> tg3 0000:00:03.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
> tg3 0000:00:03.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
> tg3 0000:00:03.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
> tg3 0000:00:03.0: eth0: Tigon3 [partno(none) rev 1002] (PCI:66MHz:64-bit) MAC address ...
> tg3 0000:00:03.0: eth0: attached PHY is 5703 (10/100/1000Base-T Ethernet) (WireSpeed[1])
> tg3 0000:00:03.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> tg3 0000:00:03.0: eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
> ...
> tg3 0000:00:03.0: eth0: No firmware running
> tg3 0000:00:03.0: eth0: Link is up at 100 Mbps, full duplex
> tg3 0000:00:03.0: eth0: Flow control is on for TX and on for RX
> 
> The three 'vpd r/w failed' messages are new and did not occur with 2.6.34
> or earlier kernels.
> 
> /Mikael
