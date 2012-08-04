Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2HDDdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 23:33:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2HDDdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 23:33:41 -0400
Date: Fri, 03 Aug 2012 20:33:41 -0700 (PDT)
Message-Id: <20120803.203341.1528759021241176441.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org, starvik@axis.com,
        jesper.nilsson@axis.com, linux-cris-kernel@axis.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] cris: fix eth_v10.c build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <501C6EEF.3030100@xenotime.net>
References: <1344002771-21072-1-git-send-email-geert@linux-m68k.org>
	<501C6EEF.3030100@xenotime.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 03 Aug 2012 17:38:07 -0700

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build error on cris (not tested, no toolchain here):
> 
> drivers/net/cris/eth_v10.c: error: too many arguments to function 'e100rxtx_interrupt'
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Applied, thanks Randy.
