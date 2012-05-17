Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab2EQJBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:01:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57650 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab2EQJBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:01:39 -0400
Date: Thu, 17 May 2012 05:00:26 -0400 (EDT)
Message-Id: <20120517.050026.6264348104559960.davem@davemloft.net>
To: joe@perches.com
Cc: nhorman@tuxdriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: Use pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337234320.17726.26.camel@joe2Laptop>
References: <1337234320.17726.26.camel@joe2Laptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 02:00:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 16 May 2012 22:58:40 -0700

> Use the current logging style.
> 
> This enables use of dynamic debugging as well.
> 
> Convert printk(KERN_<LEVEL> to pr_<level>.
> Add pr_fmt. Remove embedded prefixes, use
> %s, __func__ instead.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
