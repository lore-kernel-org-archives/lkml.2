Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab2CVCfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:35:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48884 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2CVCfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:35:09 -0400
Date: Wed, 21 Mar 2012 22:34:57 -0400 (EDT)
Message-Id: <20120321.223457.641438956547942596.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sandeep.kumar@freescale.com
Subject: Re: [PATCH] gianfar: Fix possible overrun and simplify interrupt
 name field creation
From: David Miller <davem@davemloft.net>
In-Reply-To: <17d93e9eb16cbad75b20cdbcaf38f268260d6fd5.1332010469.git.joe@perches.com>
References: <17d93e9eb16cbad75b20cdbcaf38f268260d6fd5.1332010469.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Mar 2012 19:34:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 17 Mar 2012 12:05:38 -0700

> Space allocated for int_name_<foo> is unsufficient for
> maximal device name, expand it.
> 
> Code to create int_name_<foo> is obscure, simplify it
> by using sprintf.
> 
> Found by looking for unnecessary \ line continuations.
> Uncompiled, untested.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Can a gianfar expert please review and test this patch?

Thanks.
