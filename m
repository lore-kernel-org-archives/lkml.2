Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2FMTSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:18:08 -0400
Received: from [85.118.1.10] ([85.118.1.10]:38412 "EHLO casper.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab2FMTSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:18:07 -0400
Date: Wed, 13 Jun 2012 21:18:01 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Tao Guo <glorioustao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tao Guo <Tao.Guo@emc.com>,
        Neil Brown <neilb@suse.de>, Shaohua Li <shli@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] umem: fix up unplugging
Message-ID: <20120613191801.GC8230@kernel.dk>
References: <1339088835-2614-1-git-send-email-glorioustao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339088835-2614-1-git-send-email-glorioustao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07 2012, Tao Guo wrote:
> Fix a regression introduced by 7eaceaccab5f40 ("block: remove per-queue
> plugging").  In that patch, Jens removed the whole mm_unplug_device()
> function, which used to be the trigger to make umem start to work.
> 
> We need to implement unplugging to make umem start to work, or I/O will
> never be triggered.

Applied this one, dropped the other two. Would still be nice to move
this generic functionality into the block core and unify md/umem in this
regard for 3.6, if you would like to do that.

-- 
Jens Axboe

