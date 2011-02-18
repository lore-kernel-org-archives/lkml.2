Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab1BRTjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:39:02 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43020
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab1BRTjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:39:00 -0500
Date: Fri, 18 Feb 2011 11:39:36 -0800 (PST)
Message-Id: <20110218.113936.193694941.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: xiaosuo@gmail.com, linux@horizon.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, roland@purestorage.com, dbaluta@ixiacom.com
Subject: Re: [PATCH v2] net: provide default_advmss() methods to blackhole
 dst_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298036672.6201.65.camel@edumazet-laptop>
References: <AANLkTi=O1LZzSc8=qMX=R3rJpCVL8eWr1eo6NkiZXS0m@mail.gmail.com>
	<1298036005.6201.58.camel@edumazet-laptop>
	<1298036672.6201.65.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 18 Feb 2011 14:44:32 +0100

> Le vendredi 18 février 2011 à 14:33 +0100, Eric Dumazet a écrit :
> 
>> I had this exact idea but found we need struct net pointer to get this
>> value, not provided in parameters, so I falled back to the 256 value.
>> 
>> 
> 
> Hmm, reading again this stuff, maybe we can just use
> ipv4_default_advmss() instead of a custom one.
> 
> dst->dev should be available
> 
> [PATCH] net: provide default_advmss() methods to blackhole dst_ops
> 
> Commit 0dbaee3b37e118a (net: Abstract default ADVMSS behind an
> accessor.) introduced a possible crash in tcp_connect_init(), when
> dst->default_advmss() is called from dst_metric_advmss()
> 
> Reported-by: George Spelvin <linux@horizon.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Yes, this is a lot better, applied.

Thanks!
