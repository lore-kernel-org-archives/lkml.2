Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2KLVHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:07:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2KLVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:07:29 -0500
Date: Mon, 12 Nov 2012 13:07:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Maxim Levitsky <maximlevitsky@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20121112130727.e063fa37.akpm@linux-foundation.org>
In-Reply-To: <20121112151540.16dd14cd1eef76432c098e8a@canb.auug.org.au>
References: <20121112151540.16dd14cd1eef76432c098e8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 15:15:40 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/memstick/core/ms_block.h between commit 0604fa04ccc7 ("memstick:
> add support for legacy memorysticks") that use to be in the block tree
> and commits "memstick: remove unused field from state struct", "memstick:
> ms_block: fix compile issue", "memstick: use after free in
> msb_disk_release()" and "memstick: memory leak on error in msb_ftl_scan
> ()" from the akpm tree.
> 
> The block tree commit has been dropped, so the 4 akpm tree patches no
> longer have anything to apply to, so I have dropped them.

Confused.  Who dropped "memstick: add support for legacy memorysticks"?
You, or Jens?

Assuming the block-tree memstick patches will rematerialise, I'll send
those patches at Jens.

