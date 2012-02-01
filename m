Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2BAU5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:57:46 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34559 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab2BAU5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:57:44 -0500
Date: Wed, 01 Feb 2012 15:57:39 -0500 (EST)
Message-Id: <20120201.155739.2278752934896998736.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH V2 net-next] net: dev: Convert printks to pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328129683.18641.20.camel@joe2Laptop>
References: <1328125229.18641.17.camel@joe2Laptop>
	<20120201.144305.251984620339115457.davem@davemloft.net>
	<1328129683.18641.20.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 12:57:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 01 Feb 2012 12:54:43 -0800

> Use the current logging style.
> Coalesce formats where appropriate.
> Update grammar where appropriate.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
