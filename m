Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0LHSuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:50:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42661
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569Ab0LHSui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:50:38 -0500
Date: Wed, 08 Dec 2010 10:51:05 -0800 (PST)
Message-Id: <20101208.105105.245397948.davem@davemloft.net>
To: namhyung@gmail.com
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn/hisax: fix compiler warning on hisax_pci_tbl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1291733346-11573-1-git-send-email-namhyung@gmail.com>
References: <1291733346-11573-1-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oB8IomJv005665

From: Namhyung Kim <namhyung@gmail.com>
Date: Tue,  7 Dec 2010 23:49:06 +0900

> Annotate hisax_pci_tbl as '__used' to fix following warning:
> 
>   CC      drivers/isdn/hisax/config.o
> drivers/isdn/hisax/config.c:1920: warning: ¡hisax_pci_tbl¢ defined but not used
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

This only happens because the hisax driver doesn't actually use this table
for probing.  Each sub-driver does it's own thing.

What a mess.

Anyways, applied, thank you.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
