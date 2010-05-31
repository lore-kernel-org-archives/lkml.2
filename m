Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0EaHYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:24:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40927
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab0EaHYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:24:19 -0400
Date: Mon, 31 May 2010 00:24:29 -0700 (PDT)
Message-Id: <20100531.002429.71095599.davem@davemloft.net>
To: daniel@caiaq.de
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jkosina@suse.cz,
       cl@linux-foundation.org, joe@perches.com, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/arcnet/capmode.c: clean up code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274284857-21932-1-git-send-email-daniel@caiaq.de>
References: <1274284857-21932-1-git-send-email-daniel@caiaq.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4V7OOim002574

From: Daniel Mack <daniel@caiaq.de>
Date: Wed, 19 May 2010 18:00:57 +0200

>  - shuffle around functions to get rid of forward declarations
>  - fix some CodingStyle and indentation issues
>  - last but not least, get rid of the following CONFIG_MODULE=n warning:
> 
> 	drivers/net/arcnet/capmode.c:52: warning: ¡capmode_proto¢ defined but not used
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

This does not apply cleanly to the current tree.   Please respin
this.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
