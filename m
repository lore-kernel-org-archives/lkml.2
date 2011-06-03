Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1FCF0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:26:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49268 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1FCF0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:26:20 -0400
Date: Thu, 02 Jun 2011 22:23:56 -0700 (PDT)
Message-Id: <20110602.222356.1588943715309944982.davem@davemloft.net>
To: sanagi.koki@jp.fujitsu.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, mingo@elte.hu, fweisbec@gmail.com,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] ftrace: tracepoint of net_dev_xmit sees freed skb and
 causes panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DE86B37.4070704@jp.fujitsu.com>
References: <1307048512.3667.28.camel@gandalf.stny.rr.com>
	<20110602.140426.765650914977149734.davem@davemloft.net>
	<4DE86B37.4070704@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Jun 2011 22:23:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Date: Fri, 03 Jun 2011 14:03:51 +0900

> I will resubmit this patch with appropriate subject "net/tracing:"

You don't need to, I fixed it up when I applied your patch.
