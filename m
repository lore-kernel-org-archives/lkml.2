Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1DKURJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:17:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51066
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab1DKURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:17:05 -0400
Date: Mon, 11 Apr 2011 13:16:29 -0700 (PDT)
Message-Id: <20110411.131629.59692239.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: panweiping3@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] bonding:delete two unused variables
From: David Miller <davem@davemloft.net>
In-Reply-To: <30720.1302548529@death>
References: <cover.1302509480.git.panweiping3@gmail.com>
	<30720.1302548529@death>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3BKHLee028895

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Mon, 11 Apr 2011 12:02:09 -0700

> 
>>I found that variable alb_timer and rlb_interval_counter in struct
>>alb_bond_info are not used by other codes any more, so delete them.
>>
>>Weiping Pan(æ½˜å«å¹³) (2):
>>  bonding:delete unused alb_timer
>>  bonding:delete unused rlb_interval_counter
> 
> 	For both patches.
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
