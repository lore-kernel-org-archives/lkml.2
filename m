Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1CROBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:01:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39598 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab1CROBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:01:01 -0400
Date: Fri, 18 Mar 2011 09:51:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/36] net/mac80211,rcu: convert call_rcu(work_free_rcu)
 to kfree_rcu()
Message-ID: <20110318135145.GF5103@tuxdriver.com>
References: <4D82DC17.2090106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D82DC17.2090106@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:14:15PM +0800, Lai Jiangshan wrote:
> 
> 
> The rcu callback work_free_rcu() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(work_free_rcu).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

ACK -- seems fine to me...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
