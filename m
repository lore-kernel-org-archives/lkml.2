Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1FKV7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 17:59:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46956 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab1FKV7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 17:59:44 -0400
Date: Sat, 11 Jun 2011 14:58:34 -0700 (PDT)
Message-Id: <20110611.145834.2206118199013627704.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: adobriyan@gmail.com, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/m68k: Include <linux/interrupt.h> where
 needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307792335-9926-1-git-send-email-geert@linux-m68k.org>
References: <1307792335-9926-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 14:58:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 11 Jun 2011 13:38:55 +0200

 ...
> Introduced by commit a6b7a407865a ("net: remove interrupt.h inclusion from
> netdevice.h").
> 
> Include <linux/interrupt.h> in the individual drivers to fix the build.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks!
