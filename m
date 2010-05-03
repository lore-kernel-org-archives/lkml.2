Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab0ECMxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:53:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60946 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771Ab0ECMxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:53:15 -0400
Date: Mon, 3 May 2010 14:53:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nilfs <linux-nilfs@vger.kernel.org>
Subject: Re: [PATCH] nilfs2: fix sync silent failure
Message-ID: <20100503125313.GC27497@kernel.dk>
References: <20100503.210048.267730124.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503.210048.267730124.ryusuke@osrg.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03 2010, Ryusuke Konishi wrote:
> This is another fix for the silent sync failure related to sb->s_bdi.
> 
> The commit 5129a469, which was merged to -rc6, let me know this
> problem.  I'm sorry that I was late to realize this.
> 
> Nilfs uses an own get_sb callback, and needed to set s_bdi for itself.
> I confirmed this patch made ->sync_fs() called as intended.
> 
> I hope this is sent for 2.6.34.  Please let me know if you have any
> comments.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

Linus, will you pick this one up, or do you want me to merge it and send
it your way?

-- 
Jens Axboe

