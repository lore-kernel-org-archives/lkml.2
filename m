Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1FBVBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:01:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1FBVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:01:41 -0400
Date: Thu, 02 Jun 2011 13:59:13 -0700 (PDT)
Message-Id: <20110602.135913.2065173997860104604.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: sanagi.koki@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, mingo@elte.hu,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] ftrace: tracepoint of net_dev_xmit sees freed skb and
 causes panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306854867.11899.31.camel@gandalf.stny.rr.com>
References: <4DE49D52.709@jp.fujitsu.com>
	<1306854867.11899.31.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Jun 2011 13:59:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 31 May 2011 11:14:27 -0400

> Note, the subject should not be "ftrace:", but "net:" or maybe even
> "net/tracing", as this really has nothing to do with ftrace code. The
> tracepoints are more generic than ftrace.

Do you guys mind if I take this in via the net-2.6 tree?
