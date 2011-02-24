Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1BXSmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:42:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48462
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106Ab1BXSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:42:37 -0500
Date: Thu, 24 Feb 2011 10:43:13 -0800 (PST)
Message-Id: <20110224.104313.68122155.davem@davemloft.net>
To: ratbert.chuang@gmail.com
Cc: mirqus@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, ratbert@faraday-tech.com
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikE_OU_qiBUdiDP39js8jQzGqqo1FYW2uHmw3He@mail.gmail.com>
References: <AANLkTimorcNAEbSpuE_dUXKuOBZDcDcGSJ2cGefniThc@mail.gmail.com>
	<20110223.235129.02262510.davem@davemloft.net>
	<AANLkTikE_OU_qiBUdiDP39js8jQzGqqo1FYW2uHmw3He@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 24 Feb 2011 16:07:48 +0800

> On Thu, Feb 24, 2011 at 3:51 PM, David Miller <davem@davemloft.net> wrote:
>> Just emit garbage bytes into the sub-word alignment padding if the chip
>> wants to word align it's DMA writes.
> 
> Not sure what do you mean. The problem is that HW does not accept a
> base address of RX buffer which is not 8 bytes aligned.

I am saying this is what hardware should do if it has such a
restriction.
