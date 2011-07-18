Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab1GRWjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:39:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49390 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab1GRWjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:39:12 -0400
Date: Mon, 18 Jul 2011 15:39:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next: manual merge of the rcu tree with the ext4 tree
Message-ID: <20110718223909.GE2312@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110716212838.a84936541c18fb866abcc308@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716212838.a84936541c18fb866abcc308@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 09:28:38PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rcu tree got a conflict in
> fs/jbd2/journal.c between commit 4862fd6047ed ("jbd2: remove
> jbd2_dev_to_name() from jbd2 tracepoints") from the ext4 tree and commit
> a5e245951e94 ("jbd2,rcu: Convert call_rcu(free_devcache) to kfree_rcu()")
> from the rcu tree.
> 
> The former removes the function modified by the latter, so I did that.

I now have removed that patch in -rcu as well.

							Thanx, Paul
