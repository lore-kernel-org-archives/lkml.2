Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0JFERF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:17:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42343 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab0JFERD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:17:03 -0400
Date: Tue, 5 Oct 2010 21:17:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: linux-next: manual merge of the rcu tree with Linus' tree
Message-ID: <20101006041700.GA2553@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101006133825.8ca341e4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006133825.8ca341e4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 01:38:25PM +1100, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rcu tree got a conflict in
> include/linux/rcupdate.h between commit
> b3a084b9b684622b149e8dcf03855bf0d5fb588b ("rcu: rcu_read_lock_bh_held():
> disabling irqs also disables bh") from Linus' tree and commit
> ca5ecddfa8fcbd948c95530e7e817cee9fb43a3d ("rcu: define __rcu address
> space modifier for sparse") from the rcu tree.
> 
> I am not sure how to fix this, so I just used the version from the rcu
> tree.

I believe that I will have an update that will get rid of the conflict.
But I will let you be the final judge of that.  ;-)

							Thanx, Paul
