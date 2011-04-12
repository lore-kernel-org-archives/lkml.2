Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1DLWFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:05:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45529
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757255Ab1DLWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:05:46 -0400
Date: Tue, 12 Apr 2011 15:05:11 -0700 (PDT)
Message-Id: <20110412.150511.35038648.davem@davemloft.net>
To: dwalter@barracuda.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv6: RTA_PREFSRC support for ipv6 route source
 address selection
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302505409.8923.2.camel@localhost>
References: <1302505409.8923.2.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3CM5uZF008758

From: Daniel Walter <dwalter@barracuda.com>
Date: Mon, 11 Apr 2011 09:03:29 +0200

> ï»¿[ipv6] Add support for RTA_PREFSRC
> 
> This patch allows a user to select the preferred source address
> for a specific IPv6-Route. It can be set via a netlink message
> setting RTA_PREFSRC to a valid IPv6 address which must be
> up on the device the route will be bound to.
> 
> 
> Signed-off-by: Daniel Walter <dwalter@barracuda.com>

Ok, I can live with this, applied, thanks!
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
