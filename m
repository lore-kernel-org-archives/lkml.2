Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab0JXWWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:22:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41733
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030Ab0JXWWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:22:43 -0400
Date: Sun, 24 Oct 2010 15:23:06 -0700 (PDT)
Message-Id: <20101024.152306.48512783.davem@davemloft.net>
To: Joshua.Hoke@sixnet.com
Cc: nicolas.ferre@atmel.com, jpirko@redhat.com, peter.korsgaard@barco.com,
        eric.dumazet@gmail.com, haavard.skinnemoen@atmel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] macb: Don't re-enable interrupts while in polling mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <C8F551D39A7C724E987CF8DD11D3178304D02F88@svr3.sixnetio.com>
References: <C8F551D39A7C724E987CF8DD11D3178304D02F88@svr3.sixnetio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joshua Hoke" <Joshua.Hoke@sixnet.com>
Date: Tue, 19 Oct 2010 12:48:22 -0400

> diff --git a/drivers/net/macb.c b/drivers/net/macb.c
> index ff2f158..36cf594 100644
> --- a/drivers/net/macb.c
> +++ b/drivers/net/macb.c
> @@ -515,14 +515,15 @@ static int macb_poll(struct napi_struct *napi, int
> budget)

Your email client is breaking up long lines which corrupts the
patch.

Please fix this up in your email client and resubmit.

Thank you.
