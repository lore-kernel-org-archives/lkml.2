Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1FTPS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:18:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48767 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab1FTPSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:18:24 -0400
Date: Mon, 20 Jun 2011 08:17:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the rcu tree with the tip tree
Message-ID: <20110620151722.GA2933@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110620144705.c9a5513b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620144705.c9a5513b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 02:47:05PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rcu tree got conflicts in
> kernel/rcutree.c and kernel/rcutree_plugin.h between various commits from
> the tip tree and various commits from the rcu tree.
> 
> I can't easily resolve these, so I have dropped the rcu tree for today.

I will be resolving these shortly, please accept my apologies for the
hassle.

						Thanx, Paul
