Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab2I1RxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:53:22 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47564 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2I1RxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:53:20 -0400
Date: Fri, 28 Sep 2012 10:53:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com
Subject: Re: [PATCH 0/7] rcu: optimize RCU trace on the huge platform
Message-ID: <20120928175301.GC2498@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1348102268-3544-1-git-send-email-wangyun@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348102268-3544-1-git-send-email-wangyun@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092817-5518-0000-0000-000007FFE74E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 08:51:01AM +0800, Michael Wang wrote:
> This patch set optimize the RCU trace to make it perform better on the
> platform with thousands of cpus.
> 
> The optimization including:
> 	-- the cpu info will be separated by each flavor of rcu.
> 	-- implement the 'cpu units sequence reading' to avoid losing data.
> 
> Michael Wang (7):
> 	[PATCH 1/7] rcu: create directory for each flavor of rcu
> 	[PATCH 2/7] rcu: fundamental facility for 'cpu units sequence reading'
> 	[PATCH 3/7] rcu: optimize the 'rcudata' for RCU trace
> 	[PATCH 4/7] rcu: optimize the 'rcudata.csv' for RCU trace
> 	[PATCH 5/7] rcu: optimize the 'rcu_pending' for RCU trace
> 	[PATCH 6/7] rcu: replace the old interface with the new one
> 	[PATCH 7/7] rcu: remove the interface "rcudata.csv"
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  b/kernel/rcutree_trace.c |    8 +
>  kernel/rcutree_trace.c   |  368 ++++++++++++++++++++---------------------------
>  2 files changed, 170 insertions(+), 206 deletions(-)

Queued for 3.8, thank you Michael!

							Thanx, Paul

