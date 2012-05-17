Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2EQJAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:00:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57630 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489Ab2EQJAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:00:21 -0400
Date: Thu, 17 May 2012 05:00:15 -0400 (EDT)
Message-Id: <20120517.050015.719363234800027550.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] pktgen: Use pr_debug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337226641.17726.8.camel@joe2Laptop>
References: <1337226641.17726.8.camel@joe2Laptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 02:00:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 16 May 2012 20:50:41 -0700

> Convert printk(KERN_DEBUG to pr_debug which can
> enable dynamic debugging.
> 
> Remove embedded prefixes from the conversions as
> pr_fmt adds them.
> 
> Align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
