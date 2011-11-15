Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1KOCl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:41:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39548 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1KOCl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:41:56 -0500
Date: Mon, 14 Nov 2011 21:41:51 -0500 (EST)
Message-Id: <20111114.214151.1988775203701808195.davem@davemloft.net>
To: grundler@chromium.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw
Subject: Re: [PATCH 5/5] net-next:asix: update VERSION and white space
 changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111114.213255.2061756136146824209.davem@davemloft.net>
References: <20111114.184240.1832866874941847383.davem@davemloft.net>
	<CANEJEGuzdxDuVysuAJPcdC7-mywa8B8JggVHe_VMTK_1j4QguQ@mail.gmail.com>
	<20111114.213255.2061756136146824209.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 Nov 2011 18:41:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAF2gC5b021530

From: David Miller <davem@davemloft.net>
Date: Mon, 14 Nov 2011 21:32:55 -0500 (EST)

> From: Grant Grundler <grundler@chromium.org>
> Date: Mon, 14 Nov 2011 16:54:35 -0800
> 
>> On Mon, Nov 14, 2011 at 3:42 PM, David Miller <davem@davemloft.net> wrote:
>> ...
>>> Please, just submit this without the whitespace and other cleanup
>>> stuff.  Restrict it to real bug fixes, and I'll push it around.
>> 
>> I just sent a "v2" of 5/5 patch which only has the VERSION change. Is
>> that sufficient or should I resend all 5?
> 
> Just respinning #5 is fine, thanks.

But the fact that the other bits don't even compile... that's not fine.

drivers/net/usb/asix.c: In function ¡ax88178_bind¢:
drivers/net/usb/asix.c:1463:2: error: implicit declaration of function ¡ax88178_sw_reset¢ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

[davem@boricha net]$ git grep ax88178_sw_reset
drivers/net/usb/asix.c:	ax88178_sw_reset(dev, 0);

Come on man... are you kidding me?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
