Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0HXDww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:52:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49037
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407Ab0HXDwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:52:50 -0400
Date: Mon, 23 Aug 2010 20:53:06 -0700 (PDT)
Message-Id: <20100823.205306.133908715.davem@davemloft.net>
To: sanagi.koki@jp.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com, rostedt@goodmis.org,
        eric.dumazet@gmail.com, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH v4 4/5] skb: add tracepoints to freeing skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C724364.50903@jp.fujitsu.com>
References: <4C72422C.5070102@jp.fujitsu.com>
	<4C724364.50903@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Date: Mon, 23 Aug 2010 18:46:12 +0900

> This patch adds tracepoint to consume_skb and add trace_kfree_skb before
> __kfree_skb in skb_free_datagram_locked and net_tx_action.
> Combinating with tracepoint on dev_hard_start_xmit, we can check how long it
> takes to free transmited packets. And using it, we can calculate how many
> packets driver had at that time. It is useful when a drop of transmited packet
> is a problem.
> 
>             sshd-6828  [000] 112689.258154: consume_skb: skbaddr=f2d99bb8
> 
> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
