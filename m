Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1FBVEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:04:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35747 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1FBVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:04:54 -0400
Date: Thu, 02 Jun 2011 14:03:48 -0700 (PDT)
Message-Id: <20110602.140348.1547123834732953969.davem@davemloft.net>
To: joe@perches.com
Cc: kaber@trash.net, greearb@candelatech.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next when it opens] net: 8021q: Add pr_fmt
From: David Miller <davem@davemloft.net>
In-Reply-To: <6d2f6a1e6365b8865fd210e88d257ca0bc7ad0fa.1306442986.git.joe@perches.com>
References: <20110526.145601.735416831290933990.davem@davemloft.net>
	<6d2f6a1e6365b8865fd210e88d257ca0bc7ad0fa.1306442986.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Jun 2011 14:03:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 26 May 2011 13:58:31 -0700

> Use the current logging style.
> 
> Add #define pr_fmt and remove embedded prefix from formats.
> 
> Not converting the current pr_<level> uses to netdev_<level>
> because all the output here is nicely prefaced with "8021q: ".
> 
> Remove __func__ use from proc registration failure message.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I'll apply this, thanks Joe.
