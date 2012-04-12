Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609Ab2DLTre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:47:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40838 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934668Ab2DLTrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:47:31 -0400
Date: Thu, 12 Apr 2012 15:46:24 -0400 (EDT)
Message-Id: <20120412.154624.736628097737735623.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: msink@permonline.ru, paul.gortmaker@windriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wiznet: Add missing #include <linux/irq.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334258363-17617-1-git-send-email-geert@linux-m68k.org>
References: <1334258363-17617-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 12:46:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3CJlfbu012199

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 12 Apr 2012 21:19:23 +0200

> m68k/allmodconfig:
> 
> drivers/net/ethernet/wiznet/w5100.c: In function ¡w5100_hw_probe¢:
> drivers/net/ethernet/wiznet/w5100.c:680: error: ¡IRQ_TYPE_LEVEL_LOW¢ undeclared (first use in this function)
> drivers/net/ethernet/wiznet/w5300.c: In function ¡w5300_hw_probe¢:
> drivers/net/ethernet/wiznet/w5300.c:594: error: ¡IRQ_TYPE_LEVEL_LOW¢ undeclared (first use in this function)
> 
> Include <linux/irq.h>, which provides the declaration for IRQ_TYPE_LEVEL_LOW.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
