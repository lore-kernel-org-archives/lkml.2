Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2ENWBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:01:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59833 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab2ENWBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:01:34 -0400
Date: Mon, 14 May 2012 17:59:27 -0400 (EDT)
Message-Id: <20120514.175927.44485931953538590.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: geert@linux-m68k.org, edumazet@google.com, dave.taht@bufferbloat.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH -next] net/codel: Add missing #include
 <linux/prefetch.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337029498.8512.624.camel@edumazet-glaptop>
References: <1337024825-20130-1-git-send-email-geert@linux-m68k.org>
	<1337029498.8512.624.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 May 2012 14:59:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4EM1jGi006346

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 May 2012 23:04:58 +0200

> On Mon, 2012-05-14 at 21:47 +0200, Geert Uytterhoeven wrote:
>> m68k allmodconfig:
>> 
>> net/sched/sch_codel.c: In function ¡dequeue¢:
>> net/sched/sch_codel.c:70: error: implicit declaration of function ¡prefetch¢
>> make[1]: *** [net/sched/sch_codel.o] Error 1
>> 
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
> 
> I plaid guilty
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
