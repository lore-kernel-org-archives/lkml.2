Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1CUJsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 05:48:38 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:32947 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1CUJsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 05:48:36 -0400
Message-ID: <4D871EF2.7010801@kernel.dk>
Date: Mon, 21 Mar 2011 10:48:34 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
References: <20110321114306.3d91bfb5.sfr@canb.auug.org.au>
In-Reply-To: <20110321114306.3d91bfb5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-21 01:43, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in fs/super.c
> between commit 9d412a43c3b2 ("vfs: split off vfsmount-related parts of
> vfs_kern_mount()") from Linus' tree and commit 95f28604a65b ("fs: assign
> sb->s_bdi to default_backing_dev_info if the bdi is going away") from the
> block tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks Stephen, your fixup is (obviously) correct.

-- 
Jens Axboe

