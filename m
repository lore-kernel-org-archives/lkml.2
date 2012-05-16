Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab2EPFZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:25:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45519 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2EPFZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:25:33 -0400
Date: Wed, 16 May 2012 01:23:19 -0400 (EDT)
Message-Id: <20120516.012319.1903390658912592000.davem@davemloft.net>
To: joe@perches.com
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] net: mac80211: Neaten debugging
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1337116578.git.joe@perches.com>
References: <1337106548.15553.8.camel@jlt3.sipsolutions.net>
	<cover.1337116578.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 22:23:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 15 May 2012 14:20:29 -0700

> Always use pr_debug variants instead of printk(KERN_DEBUG...)
> 
> Joe Perches (3):
>   net: mac80211: Convert printk(KERN_DEBUG to pr_debug
>   net: mac80211: Add and use ht_vdbg debugging macro
>   net: mac80211: Add and use ibss_vdbg debugging macro

I really think this is the right thing to do and I hope the wireless
folks integrate this.

I am well aware that you guys intend for some of these messages to be
indications and notifications the user is intended to SEE, but in the
cases where that is true KERN_DEBUG is absolutely not appropriate.

You should be using KERN_INFO or KERN_WARN in those situations
instead.

Thanks.
