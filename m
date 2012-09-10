Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2IJUpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:45:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33724 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2IJUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:45:15 -0400
Date: Mon, 10 Sep 2012 16:45:13 -0400 (EDT)
Message-Id: <20120910.164513.400687476300645876.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH -next] net: fix net/core/sock.c build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <504E1193.4060809@xenotime.net>
References: <20120910172407.c5ad953c008165fcd862bd3c@canb.auug.org.au>
	<504E1193.4060809@xenotime.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 10 Sep 2012 09:13:07 -0700

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix net/core/sock.c build error when CONFIG_INET is not enabled:
> 
> net/built-in.o: In function `sock_edemux':
> (.text+0xd396): undefined reference to `inet_twsk_put'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Applied to 'net', thanks Randy.
