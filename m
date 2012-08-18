Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2HRVIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:08:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35267 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2HRVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:08:09 -0400
Date: Sat, 18 Aug 2012 14:08:06 -0700 (PDT)
Message-Id: <20120818.140806.1408326124840020051.davem@davemloft.net>
To: jslaby@suse.cz
Cc: netdev@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Priyanka.Jain@freescale.com
Subject: Re: [PATCH] NET: xfrm, use correct rcu dereference helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <1345210716-24556-1-git-send-email-jslaby@suse.cz>
References: <1345210716-24556-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 17 Aug 2012 15:38:36 +0200

> Use rcu_dereference_bh while holding bh rcu lock. Otherwise we get:
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.6.0-rc1-next-20120816+ #10 Not tainted
> -------------------------------
> net/xfrm/xfrm_policy.c:2504 suspicious rcu_dereference_check() usage!
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Priyanka Jain <Priyanka.Jain@freescale.com>

Should already be fixed in net-next for at least a whole day now.
