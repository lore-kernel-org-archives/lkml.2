Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0LaUvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 15:51:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39636
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab0LaUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 15:51:52 -0500
Date: Fri, 31 Dec 2010 12:52:23 -0800 (PST)
Message-Id: <20101231.125223.212690412.davem@davemloft.net>
To: julia@diku.dk
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/atm/atmtcp.c: add missing atm_dev_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1012291500310.8559@pc-004.diku.dk>
References: <Pine.LNX.4.64.1012291500310.8559@pc-004.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Wed, 29 Dec 2010 15:01:03 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> The earlier call to atm_dev_lookup increases the reference count of dev,
> so decrease it on the way out.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thank you.
