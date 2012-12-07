Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424213Ab2LGD0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 22:26:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50703 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424136Ab2LGD0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 22:26:00 -0500
Date: Thu, 06 Dec 2012 22:25:56 -0500 (EST)
Message-Id: <20121206.222556.600775306911649606.davem@davemloft.net>
To: dinggnu@gmail.com
Cc: ebiederm@xmission.com, edumazet@google.com, xemul@parallels.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: fix unused variable sparse warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121207001545.GE2510@gmail.com>
References: <1354838913-20084-1-git-send-email-dinggnu@gmail.com>
	<20121207001545.GE2510@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB73Q3I5024261

From: Cong Ding <dinggnu@gmail.com>
Date: Fri, 7 Dec 2012 00:15:47 +0000

> On Fri, Dec 07, 2012 at 12:06:44AM +0000, Cong Ding wrote:
>> the variables zero and unres_qlen_max are only used when CONFIG_SYSCTL is
>> defined, otherwise it causes the following sparse warning when we turn on
>> CONFIG_SYSCTL.
> sorry for disturbing again, the sparse warning is
> net/core/neighbour.c:65:12: warning: ¡zero¢ defined but not used [-Wunused-variable]
> net/core/neighbour.c:66:12: warning: ¡unres_qlen_max¢ defined but not used [-Wunused-variable]
> 
> it happens if we turn off CONFIG_SYSCTL.

A patch for this has already in my tree for nearly a whole day.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
