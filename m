Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1IUTRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:17:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35929 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1IUTRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:17:09 -0400
Date: Wed, 21 Sep 2011 15:17:01 -0400 (EDT)
Message-Id: <20110921.151701.1605320247440880043.davem@davemloft.net>
To: wanlong.gao@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        omarapazanadi@gmail.com, gaofeng@cn.fujitsu.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH resend] fib:fix BUG_ON in fib_nl_newrule when add new
 fib rule
From: David Miller <davem@davemloft.net>
In-Reply-To: <1315791365-5324-1-git-send-email-wanlong.gao@gmail.com>
References: <1315675150-3012-1-git-send-email-wanlong.gao@gmail.com>
	<1315791365-5324-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Sep 2011 12:17:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>
Date: Mon, 12 Sep 2011 09:36:05 +0800

> From: Gao feng <gaofeng@cn.fujitsu.com>
> 
> add new fib rule can cause BUG_ON happen
> the reproduce shell is
> ip rule add pref 38
> ip rule add pref 38
> ip rule add to 192.168.3.0/24 goto 38
> ip rule del pref 38
> ip rule add to 192.168.3.0/24 goto 38
> ip rule add pref 38
> 
> then the BUG_ON will happen
> del BUG_ON and use (ctarget == NULL) identify whether this rule is unresolved
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks a lot.
