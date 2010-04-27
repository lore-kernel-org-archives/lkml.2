Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0D0Xmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:42:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44842
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249Ab0D0Xme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:42:34 -0400
Date: Tue, 27 Apr 2010 16:42:39 -0700 (PDT)
Message-Id: <20100427.164239.73369551.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: miles.lane@gmail.com, ebiederm@xmission.com, vgoyal@redhat.com,
       eparis@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu,
       peterz@infradead.org, linux-kernel@vger.kernel.org, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org, jens.axboe@oracle.com,
       guijianfeng@cn.fujitsu.com, lizf@cn.fujitsu.com,
       johannes@sipsolutions.net
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100427233111.GF2424@linux.vnet.ibm.com>
References: <20100427162201.GA5826@linux.vnet.ibm.com>
	<g2ya44ae5cd1004271058p9f73fba1v3f611693e81869c3@mail.gmail.com>
	<20100427233111.GF2424@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 27 Apr 2010 16:31:11 -0700

> Thank you both!  I have added Eric's Acked-by and Miles's Tested-by.

How can you?  It's in net-next-2.6 already :-)
