Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0DUXTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:19:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33820
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402Ab0DUXTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:19:43 -0400
Date: Wed, 21 Apr 2010 16:19:48 -0700 (PDT)
Message-Id: <20100421.161948.253502140.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] fasync: RCU locking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271230961.16881.630.camel@edumazet-laptop>
References: <1271230961.16881.630.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 14 Apr 2010 09:42:41 +0200

> [PATCH net-next-2.6] fasync: RCU locking
> 
> kill_fasync() uses a central rwlock, candidate for RCU conversion.
> 
> We can remove __kill_fasync() direct use in net, and rename it to
> kill_fasync_rcu()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

This looks good to me, applied, thanks Eric.
