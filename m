Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0LSDf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 22:35:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:45973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab0LSDf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 22:35:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,195,1291622400"; 
   d="scan'208";a="688542670"
Date: Sun, 19 Dec 2010 11:35:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <jaxboe@fusionio.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Shane Michael Matthews <shane.matthews@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Luck, Tony" <tony.luck@intel.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] Add readpages support for block devices
Message-ID: <20101219033552.GA9247@localhost>
References: <1292632073-6196-1-git-send-email-willy@linux.intel.com>
 <20101218092049.GA32442@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218092049.GA32442@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 10:20:49AM +0100, Christoph Hellwig wrote:
> We already used to have this and Jens reverted it in commit
> 172124e220f1854acc99ee394671781b8b5e2120.  I can't find a better
> explanation than his rather brief commit message, but he might not more.

The discussion goes here

http://www.gossamer-threads.com/lists/linux/kernel/1085325?do=post_view_threaded#1085325

The problem happens on ext3 fs, non-4k aligned partition and 64K page
size. Jeff also find it hurts dump performance. Then it's reverted
since no one seems to have the time to dig further.

Thanks,
Fengguang
