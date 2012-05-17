Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2EQJA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:00:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57632 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489Ab2EQJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:00:24 -0400
Date: Thu, 17 May 2012 05:00:21 -0400 (EDT)
Message-Id: <20120517.050021.2267474481756476710.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipv6: ndisc: Neaten ND_PRINTx macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337232518.17726.21.camel@joe2Laptop>
References: <1337232518.17726.21.camel@joe2Laptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 02:00:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 16 May 2012 22:28:38 -0700

> Why use several macros when one will do?
> 
> Convert the multiple ND_PRINTKx macros to a single
> ND_PRINTK macro.  Use the new net_<level>_ratelimited
> mechanism too.
> 
> Add pr_fmt with "ICMPv6: " as prefix.
> Remove embedded ICMPv6 prefixes from messages.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
