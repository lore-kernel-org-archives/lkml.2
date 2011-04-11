Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1DKUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:16:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51061
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab1DKUQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:16:58 -0400
Date: Mon, 11 Apr 2011 13:16:22 -0700 (PDT)
Message-Id: <20110411.131622.39194423.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: panweiping3@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding:set save_load to 0 when initializing
From: David Miller <davem@davemloft.net>
In-Reply-To: <30474.1302548207@death>
References: <1302270019-11698-1-git-send-email-panweiping3@gmail.com>
	<30474.1302548207@death>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3BKH5e8028891

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Mon, 11 Apr 2011 11:56:47 -0700

> 
>>It is unnecessary to set save_load to 1 here,
>>as the tx_hashtbl is just kzalloced.
>>
>>Signed-off-by: Weiping Pan(æ½˜å«å¹³) <panweiping3@gmail.com>
> 
> 	I don't think this will cause any behavioral change, but I'll
> grant is more correct in intent (there's no load information to save at
> this point).
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
