Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576Ab2EQWpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:45:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35816 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030492Ab2EQWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:45:44 -0400
Date: Thu, 17 May 2012 18:45:40 -0400 (EDT)
Message-Id: <20120517.184540.2184273930158423710.davem@davemloft.net>
To: joe@perches.com
Cc: linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] lapb: Neaten debugging
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337286349.17726.58.camel@joe2Laptop>
References: <1337286349.17726.58.camel@joe2Laptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 15:45:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 17 May 2012 13:25:49 -0700

> Enable dynamic debugging and remove a bunch of #ifdef/#endifs.
> 
> Add a lapb_dbg(level, fmt, ...) macro and replace the
> printk(KERN_DEBUG uses.
> Add pr_fmt and remove embedded prefixes.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
