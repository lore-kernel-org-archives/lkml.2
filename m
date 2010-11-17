Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0KQCMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:12:52 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:42301 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934095Ab0KQCMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:12:48 -0500
Date: Wed, 17 Nov 2010 13:12:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] [rfc] dcache scaling part 1
Message-ID: <20101117021244.GM22876@dastard>
References: <20101116140900.039761100@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116140900.039761100@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 01:09:00AM +1100, Nick Piggin wrote:
> There are 3 main parts to dcache scaling. This one primarily adds new locks
> to take over dcache_lock, and some pre/post prep and streamlining patches.
> 
> The second implements fine grained locking, and is rather trivial after
> part 1.
> 
> The third implements rcu-walk. rcu-walk depends on the first part, because it
> relies on using d_lock to protect the state of the dentry (when converting from
> rcu-walk to refcounted walk). Without the fine grained locing, we'd need to use
> dcache_lock for that, which would be a step backwards to put into path walking
> again.
> 
> Comments?

Do you have a git tree somewhere with this series in it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
