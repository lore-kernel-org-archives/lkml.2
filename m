Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2EMDfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 23:35:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45880 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2EMDfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 23:35:17 -0400
Date: Sat, 12 May 2012 23:35:13 -0400 (EDT)
Message-Id: <20120512.233513.1428430627278045925.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] etherdevice: Remove now unused
 compare_ether_addr_64bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336774866.13434.16.camel@joe2Laptop>
References: <acb363688c8ed729cc61e288605cdb4aa4089149.1336618708.git.joe@perches.com>
	<20120510.233554.263340913611469229.davem@davemloft.net>
	<1336774866.13434.16.camel@joe2Laptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 12 May 2012 20:35:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 11 May 2012 15:21:06 -0700

> Move and invert the logic from the otherwise unused
> compare_ether_addr_64bits to ether_addr_equal_64bits.
> 
> Neaten the logic in is_etherdev_addr.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
