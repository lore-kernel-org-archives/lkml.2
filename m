Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab0IBKiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:38:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab0IBKiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:38:50 -0400
Subject: Re: [PATCH] cls_cgroup: Fix rcu lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Dave Jones <davej@redhat.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <4C7F446F.8040303@cn.fujitsu.com>
References: <4C7F446F.8040303@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Sep 2010 12:38:36 +0200
Message-ID: <1283423916.2059.1847.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 14:30 +0800, Li Zefan wrote:
> Calling task_subsys_state() without holding rcu_read_lock or
> cgroup_mutex can cause lockdep warning.
> 

That is not a suitable changelog.

Was the warning correct? Is your patch correct? What does RCU protect
here and why can we use classid after dropping it.

Simply frobbing code to make the warning go away is not good.
