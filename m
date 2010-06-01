Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0FAI2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:28:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50493
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab0FAI2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:28:16 -0400
Date: Tue, 01 Jun 2010 01:28:24 -0700 (PDT)
Message-Id: <20100601.012824.186321680.davem@davemloft.net>
To: isdn@linux-pingi.de
Cc: julia@diku.dk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/isdn/hardware/mISDN: Use GFP_ATOMIC when a
 lock is held
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100601080535.GA19288@gw.linux-pingi.de>
References: <Pine.LNX.4.64.1005301549230.15938@ask.diku.dk>
	<20100601080535.GA19288@gw.linux-pingi.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <isdn@linux-pingi.de>
Date: Tue, 1 Jun 2010 10:05:35 +0200

> thanks for that report, the issue is valid, but I think the fix in that case
> should be to move the allocation to an other place, to avoid wasting of
> GFP_ATOMIC allocation. I will come up with an other fix.

You'll have to write your patch relative to Julia'a s ince it's already
in my net-2.6 tree, since it's a bug fix.
