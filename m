Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab0KOSVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:21:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54906
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933309Ab0KOSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:21:45 -0500
Date: Mon, 15 Nov 2010 10:22:10 -0800 (PST)
Message-Id: <20101115.102210.242124777.davem@davemloft.net>
To: sam@ravnborg.org
Cc: cmetcalf@tilera.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        shemminger@vyatta.com, eric.dumazet@gmail.com
Subject: Re: [PATCH v2] drivers/net/tile/: on-chip network drivers for the
 tile architecture
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101114075213.GA15495@merkur.ravnborg.org>
References: <4CD1CE62.9010307@tilera.com>
	<201011140335.oAE3Zuqg032279@farm-0027.internal.tilera.com>
	<20101114075213.GA15495@merkur.ravnborg.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 14 Nov 2010 08:52:13 +0100

>> diff --git a/drivers/net/tile/Makefile b/drivers/net/tile/Makefile
>> new file mode 100644
>> index 0000000..f634f14
>> --- /dev/null
>> +++ b/drivers/net/tile/Makefile
>> @@ -0,0 +1,10 @@
>> +#
>> +# Makefile for the TILE on-chip networking support.
>> +#
>> +
>> +obj-$(CONFIG_TILE_NET) += tile_net.o
>> +ifdef CONFIG_TILEGX
>> +tile_net-objs := tilegx.o mpipe.o iorpc_mpipe.o dma_queue.o
>> +else
>> +tile_net-objs := tilepro.o
>> +endif
> 
> The -objs syntax is deprecated these days.
> Preferred syntax for the above is:

Also please fix the date on your computer, or please change whatever
it is that makes your patch postings use a date in the past.

Thanks.
