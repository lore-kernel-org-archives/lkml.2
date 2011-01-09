Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1AIXpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:45:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46382
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149Ab1AIXp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:45:29 -0500
Date: Sun, 09 Jan 2011 15:46:01 -0800 (PST)
Message-Id: <20110109.154601.116374791.davem@davemloft.net>
To: jj@chaosbits.net
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Madge Ambassador ATM Adapter driver: Always
 release_firmware() in ucode_init() and don't leak memory.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1101092229160.633@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101062203160.13988@swampdragon.chaosbits.net>
	<20110107100239.28032e5d@thirdoffive.cmf.nrl.navy.mil>
	<alpine.LNX.2.00.1101092229160.633@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 9 Jan 2011 22:32:38 +0100 (CET)

> Failure to call release_firmware() will result in memory leak in
> drivers/atm/ambassador.c::ucode_init().
> This patch makes sure we always call release_firmware() when needed, 
> thus removing the leak(s).
> 
> Yes, I know checkpatch complains about this patch, but it was either that 
> or completely mess up the existing style, so I opted to use the existing 
> style and live with the checkpatch related flak.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
