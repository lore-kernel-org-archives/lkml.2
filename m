Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2AaVlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:41:19 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52947 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab2AaVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:41:18 -0500
Date: Tue, 31 Jan 2012 16:41:14 -0500 (EST)
Message-Id: <20120131.164114.2078156017513708279.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net: Remove alloc_etherdev error
 messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327880872.2652.12.camel@joe2Laptop>
References: <1327877783.2652.10.camel@joe2Laptop>
	<1327880872.2652.12.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 13:41:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 29 Jan 2012 15:47:52 -0800

> alloc_etherdev has a generic OOM/unable to alloc message.
> Remove the duplicative messages after alloc_etherdev calls.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
