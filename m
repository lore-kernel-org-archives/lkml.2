Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1JJTSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:18:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39967 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1JJTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:18:10 -0400
Date: Mon, 10 Oct 2011 15:17:51 -0400 (EDT)
Message-Id: <20111010.151751.157914839044682434.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: johfel@gmx.de, torvalds@linux-foundation.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: Fix file references in drivers/ide/
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E933B4C.5050104@xenotime.net>
References: <1317683499.5990.2.camel@LAPJFS>
	<4E933B4C.5050104@xenotime.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 10 Oct 2011 12:17:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 10 Oct 2011 11:37:00 -0700

> From: Johann Felix Soden <johfel@users.sourceforge.net>
> 
> Fix file references in drivers/ide/
> 
> There are a lot of file references to now moved or deleted files in the
> whole tree, especially in documentation and Kconfig files. This patch
> fixes the references in drivers/ide/.
> 
> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: David S. Miller <davem@davemloft.net>
