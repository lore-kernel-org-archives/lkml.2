Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2IVTw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 15:52:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2IVTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 15:52:58 -0400
Date: Sat, 22 Sep 2012 15:52:55 -0400 (EDT)
Message-Id: <20120922.155255.396667016733201083.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: subramanian.vijay@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        alexander.h.duyck@intel.com
Subject: Re: [PATCH net-next v1] net: use a per task frag allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348261871.2669.962.camel@edumazet-glaptop>
References: <1348239433.2669.522.camel@edumazet-glaptop>
	<CAGK4HS98RG78Auvaai3Ny6zz5c_hccO-ShD3GuT=moRRm4+RUA@mail.gmail.com>
	<1348261871.2669.962.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8MJr45g015667

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 21 Sep 2012 23:11:11 +0200

> On Fri, 2012-09-21 at 13:27 -0700, Vijay Subramanian wrote:
>> I get the following compile error with the newer version of the patch
>> 
>> net/sched/em_meta.c: In function ¡meta_int_sk_sendmsg_off¢:
>> net/sched/em_meta.c:464: error: ¡struct sock¢ has no member named
>> ¡sk_sndmsg_off¢
>> make[1]: *** [net/sched/em_meta.o] Error 1
>> make: *** [net/sched/em_meta.o] Error 2
>> 
>> 
>> 
>> Vijay
> 
> Oh well, I wonder what's the expected use of this crap...
> 
> Thanks, I'll fix this on v3 !

So many aspects of the meta match are an extreme burdon on development
because the keys it allows unnecessarily exposes internals of our
implementation.

Who really uses it?  Maybe we can schedule it for removal.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
