Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2KGX7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:59:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42407 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2KGX7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:59:53 -0500
Date: Wed, 07 Nov 2012 18:59:51 -0500 (EST)
Message-Id: <20121107.185951.1536161042866737820.davem@davemloft.net>
To: lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
References: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA8000Nn023425

From: Lee Jones <lee.jones@linaro.org>
Date: Wed,  7 Nov 2012 10:55:03 +0100

> It doesn't make much sense to enable ISDN services if you don't
> intend to connect to a network. Therefore insisting that ISDN
> depends on NETDEVICES seems logical. We can then remove any
> guards mentioning NETDEVICES inside all subordinate drivers.
> 
> This also has the nice side-effect of fixing the warning below
> when ISDN_I4L && !CONFIG_NETDEVICES at compile time.
> 
> This patch fixes:
> drivers/isdn/i4l/isdn_common.c: In function ¡isdn_ioctl¢:
> drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ¡s¢ [-Wunused-variable]
> 
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
