Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1ICC2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 22:28:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53220 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab1ICC2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 22:28:22 -0400
Date: Fri, 02 Sep 2011 22:28:15 -0400 (EDT)
Message-Id: <20110902.222815.1098509260641374654.davem@davemloft.net>
To: harvey.huawei.yang@gmail.com
Cc: isdn@linux-pingi.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/isdn/sc/init.c: Fix warning:passing argument 1
 of =?iso-8859-7?B?oXJlYWRsog==?= makes pointer from integer without a cast
From: David Miller <davem@davemloft.net>
In-Reply-To: <1315015339-2501-1-git-send-email-harvey.huawei.yang@gmail.com>
References: <1315015339-2501-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 02 Sep 2011 19:28:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p832SvCg016253

From: Harvey Yang <harvey.huawei.yang@gmail.com>
Date: Sat,  3 Sep 2011 10:02:19 +0800

> drivers/isdn/sc/init.c:487: warning: passing argument 1 of ¡readl¢ makes pointer from integer without a cast

We should fix this by adding random casts to every readl() call,
instead we should fix the fundamental data types being passed
in.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
