Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1EKRxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:53:44 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51210 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1EKRxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:53:43 -0400
Message-ID: <4DCACD25.6060107@kernel.dk>
Date: Wed, 11 May 2011 19:53:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) stable/blkfront for 2.6.40
References: <20110510171107.GA939@dumpdata.com>
In-Reply-To: <20110510171107.GA939@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-10 19:11, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please pull:
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/blkfront
> 
> which has changes since git commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58
> Linus Torvalds (1):
>     Linux 2.6.39-rc5
> 
> The git commit includes a bug-fix, and a set of patches to allow the blkfront
> driver to use 'feature-flush-cache' feature. The 'flush-cache' is basically
> the equivalent of the new REQ_FLUSH command (the old 'feature-barrier' is
> still present in the driver in case the backend supports that).
> 
> If you prefer for me to ask Linus to pull this git tree since it includes
> a patch to the include/xen/interface/.. directory - I can do that as long as
> you are OK with that.

I don't mind pulling it directly, that's fine. But you are based on
2.6.39-rc5, you should be based on for-2.6.40/drivers (or core) instead.
If I pull the above, I end up getting all the changes from rc4..rc5 as
well.

-- 
Jens Axboe

