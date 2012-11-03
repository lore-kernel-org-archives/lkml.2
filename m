Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2KCToA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 15:44:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2KCTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 15:43:57 -0400
Date: Sat, 03 Nov 2012 15:43:56 -0400 (EDT)
Message-Id: <20121103.154356.693234817224225347.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atp: remove set_rx_mode_8012()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351936395.1434.2.camel@x61.thuisdomein>
References: <1351936395.1434.2.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA3Ji2xl002681

From: Paul Bolle <pebolle@tiscali.nl>
Date: Sat, 03 Nov 2012 10:53:15 +0100

> Building atp.o triggers this GCC warning:
>     drivers/net/ethernet/realtek/atp.c: In function ¡set_rx_mode¢:
>     drivers/net/ethernet/realtek/atp.c:871:26: warning: ¡mc_filter[0]¢ may be used uninitialized in this function [-Wuninitialized]
> 
> GCC is correct. In promiscuous mode 'mc_filter' will be used
> uninitialized in set_rx_mode_8012(), which is apparently inlined into
> set_rx_mode().
> 
> But it turns out set_rx_mode_8012() will never be called, since
> net_local.chip_type will always be RTL8002. So we can just remove
> set_rx_mode_8012() and do some related cleanups.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
