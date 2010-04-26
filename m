Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0DZCHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 22:07:25 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48547 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab0DZCHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 22:07:24 -0400
Date: Sun, 25 Apr 2010 19:07:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, miles.lane@gmail.com, vgoyal@redhat.com,
       eparis@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu,
       peterz@infradead.org, linux-kernel@vger.kernel.org, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org, jens.axboe@oracle.com,
       guijianfeng@cn.fujitsu.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100426020716.GV2440@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <m2xa44ae5cd1004231559hcf90671asf146a43b4748c2c3@mail.gmail.com>
 <20100425023455.GM2440@linux.vnet.ibm.com>
 <1272181534.3614.1.camel@jlt3.sipsolutions.net>
 <20100425.004925.54203352.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100425.004925.54203352.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 12:49:25AM -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sun, 25 Apr 2010 09:45:34 +0200
> 
> > The station locking is a tad confusing, but I've added the right
> > annotations already, should be coming to a kernel near you soon (i.e.
> > are in net-2.6 right now).
> 
> Linus took in everything I have so it should be in Linus's tree
> by now.

Thank you both, Dave and Johannes!

							Thanx, Paul
