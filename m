Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab1ELVid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:38:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59037 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab1ELVi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:38:29 -0400
Date: Thu, 12 May 2011 17:37:20 -0400 (EDT)
Message-Id: <20110512.173720.2197201133223265905.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: panweiping3@gmail.com, therbert@google.com, mirq-linux@rere.qmqm.pl,
        bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net:set valid name before calling ndo_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305214382.3795.28.camel@edumazet-laptop>
References: <1305207541-13311-1-git-send-email-panweiping3@gmail.com>
	<1305214382.3795.28.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:37:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4CLckie010460

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 12 May 2011 17:33:02 +0200

> Le jeudi 12 mai 2011 Ã  21:39 +0800, Weiping Pan(æ½˜å«å¹³) a Ã©crit :
>> From: Pan Weiping <panweiping3@gmail.com>
>> 
>> A bug of bonding was invloved by e815d19ffe02bdfda1260949ef2b1806171,
>> see example 1 and 2.
>> 
> 
> I cant find e815d19ffe02bdfda1260949ef2b1806171 in net-next-2.6
> 
> but I do find 1c5cae815d19ffe02bdfda1260949ef2b1806171
> 
> Please always use following when referring to a commit :
> 
> ... in commit 1c5cae815d19 (net: call dev_alloc_name from
> register_netdevice) ...
> 
> - just limit to _first_ 12 chars, no need to have full length
> - give the commit title

Pan, please fix this commit reference up and resubmit your patch.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
