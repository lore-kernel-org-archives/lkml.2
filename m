Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2AZVh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:37:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34825 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2AZVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:37:27 -0500
Date: Thu, 26 Jan 2012 16:37:25 -0500 (EST)
Message-Id: <20120126.163725.208323115932061885.davem@davemloft.net>
To: steweg@ynet.sk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2, kernel 3.2.1] RTNETLINK adjusting values of
 min_ifinfo_dump_size
From: David Miller <davem@davemloft.net>
In-Reply-To: <3280801.2791327611666778.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <3280801.2791327611666778.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 13:37:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Thu, 26 Jan 2012 22:01:06 +0100 (CET)

> From: Stefan Gula <steweg@gmail.com>
> 
> Setting link parameters on a netdevice changes the value
> of if_nlmsg_size(), therefore it is necessary to recalculate
> min_ifinfo_dump_size.
> 
> Signed-off-by: Stefan Gula <steweg@gmail.com>

Applied, but:

> +	min_ifinfo_dump_size = max_t(u16, if_nlmsg_size(dev),
> +					min_ifinfo_dump_size);
> +

The second line is not properly indented, the first non-space
character should line up with the first column after the
openning parenthesis on the previous line.

I fixed this up, but really this was a lot of tooth pulling to
get you to post this patch correctly.  You cannot consume this
much maintainer and reviewer resources in the future.

