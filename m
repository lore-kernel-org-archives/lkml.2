Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1DLWRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:17:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33626
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932541Ab1DLWRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:17:34 -0400
Date: Tue, 12 Apr 2011 15:16:59 -0700 (PDT)
Message-Id: <20110412.151659.15244967.davem@davemloft.net>
To: dwalter@barracuda.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv6: RTA_PREFSRC support for ipv6 route source
 address selection
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110412.150511.35038648.davem@davemloft.net>
References: <1302505409.8923.2.camel@localhost>
	<20110412.150511.35038648.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3CMHipO008810

From: David Miller <davem@davemloft.net>
Date: Tue, 12 Apr 2011 15:05:11 -0700 (PDT)

> From: Daniel Walter <dwalter@barracuda.com>
> Date: Mon, 11 Apr 2011 09:03:29 +0200
> 
>> ï»¿[ipv6] Add support for RTA_PREFSRC
>> 
>> This patch allows a user to select the preferred source address
>> for a specific IPv6-Route. It can be set via a netlink message
>> setting RTA_PREFSRC to a valid IPv6 address which must be
>> up on the device the route will be bound to.
>> 
>> 
>> Signed-off-by: Daniel Walter <dwalter@barracuda.com>
> 
> Ok, I can live with this, applied, thanks!

Sorry, I had to revert.

Please fix this warning, test your patch, and resubmit it.

net/ipv6/ip6_output.c: In function â€˜ip6_dst_lookup_tailâ€™:
net/ipv6/ip6_output.c:936: warning: passing argument 3 of â€˜ip6_route_get_saddrâ€™ from incompatible pointer type
include/net/ip6_route.h:87: note: expected â€˜struct in6_addr *â€™ but argument is of type â€˜struct dst_entry **â€™

Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
