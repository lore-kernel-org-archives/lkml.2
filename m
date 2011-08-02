Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1HBL3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:29:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54128 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1HBL3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:29:49 -0400
Date: Tue, 02 Aug 2011 04:29:44 -0700 (PDT)
Message-Id: <20110802.042944.2000448046653992449.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: shemminger@vyatta.com, eric.dumazet@gmail.com, mchan@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: convert uses of rcu_assign_pointer(x, NULL) to
 RCU_INIT_POINTER
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110802103216.GB2352@linux.vnet.ibm.com>
References: <20110801091900.1027396f@nehalam.ftrdhcpuser.net>
	<20110801.224401.31810103988544647.davem@davemloft.net>
	<20110802103216.GB2352@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 02 Aug 2011 04:29:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 2 Aug 2011 03:32:16 -0700

> This patch does not depend on Eric's earlier patch because
> RCU_INIT_POINTER() already exists.  So although I would be happy to
> carry this patch, there is no reason I can see not to run it up through
> net-next.  Either way, the Coccinelle script does look generally
> useful.  ;-)
> 
> If you would prefer me to carry it, please let me know.  Otherwise:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I've queued it up for net-next, thanks!
