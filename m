Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1GLFQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:16:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54000 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1GLFQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:16:48 -0400
Date: Mon, 11 Jul 2011 22:15:20 -0700 (PDT)
Message-Id: <20110711.221520.315256855290511409.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, gregkh@suse.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org, marius@kotsbak.com
Subject: Re: [PATCH 7/7] drivers/net: static should be at beginning of
 declaration
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1107092322320.25516@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1107092322320.25516@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 11 Jul 2011 22:16:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6C5H9cl013749

From: Jesper Juhl <jj@chaosbits.net>
Date: Sat, 9 Jul 2011 23:24:43 +0200 (CEST)

> Make sure that the 'static' keywork is at the beginning of declaration
> for drivers/net/usb/kalmia.c
> 
> This gets rid of warnings like
>   warning: ¡static¢ is not at beginning of declaration
> when building with -Wold-style-declaration (and/or -Wextra which also
> enables it).
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied to net-next-2.6, thanks!
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
