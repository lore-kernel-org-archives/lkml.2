Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0FVVGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:06:15 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51295 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0FVVGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:06:14 -0400
Date: Tue, 22 Jun 2010 14:06:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the tip tree with the block tree
Message-ID: <20100622210607.GN2290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100622143121.186fe9c4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622143121.186fe9c4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 02:31:21PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> fs/fs-writeback.c between commit 79338d2a78ab78efdc1698f1309766a039addf9d
> ("writeback: simplify the write back thread queue") from the block tree
> and commit b97181f24212f4c29197890ce1b2b9100bcc184d ("fs: remove all rcu
> head initializations, except on_stack initializations") from the tip tree.
> 
> This time it is not clear if the RCU updates are needed any more at all,
> so for today I just used the version of fs/fs-writeback.c from the block
> tree.

The current -next tree has gotten rid of all teh RCU_INIT_HEAD, RCU_HEAD,
and INIT_RCU_HEAD calls, as it should.  Woo-hoo!!!  ;-)

							Thanx, Paul
