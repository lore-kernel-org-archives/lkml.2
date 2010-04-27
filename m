Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0D0XxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:53:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40826 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab0D0XxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:53:01 -0400
Date: Tue, 27 Apr 2010 16:52:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: miles.lane@gmail.com, ebiederm@xmission.com, vgoyal@redhat.com,
       eparis@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu,
       peterz@infradead.org, linux-kernel@vger.kernel.org, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org, jens.axboe@oracle.com,
       guijianfeng@cn.fujitsu.com, lizf@cn.fujitsu.com,
       johannes@sipsolutions.net
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100427235255.GH2424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100427162201.GA5826@linux.vnet.ibm.com>
 <g2ya44ae5cd1004271058p9f73fba1v3f611693e81869c3@mail.gmail.com>
 <20100427233111.GF2424@linux.vnet.ibm.com>
 <20100427.164239.73369551.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427.164239.73369551.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 04:42:39PM -0700, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Tue, 27 Apr 2010 16:31:11 -0700
> 
> > Thank you both!  I have added Eric's Acked-by and Miles's Tested-by.
> 
> How can you?  It's in net-next-2.6 already :-)

OK, OK, I will drop my copy.  ;-)

							Thanx, Paul
