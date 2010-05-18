Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0ERLp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:45:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35148 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab0ERLp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:45:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the drbd tree with the block tree
Date: Tue, 18 May 2010 13:45:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31-19-generic; KDE/4.3.5; i686; ; )
Cc: drbd-dev@lists.linbit.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100518152031.9a244971.sfr@canb.auug.org.au>
In-Reply-To: <20100518152031.9a244971.sfr@canb.auug.org.au>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005181345.22986.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

FYI:
I use 
git://git.drbd.org/linux-2.6-drbd.git for-jens
as path of my patches to Jens.

I switched that tree to Jens' 
git://git.kernel.dk/linux-2.6-block.git for-2.6.35
and provided the DRBD patches on top of that.

Not that I am not willing to help, I have the feeling that this
merge conflict has nothing to do with DRBD.

Best,
 Phil

> Hi all,
> 
> Today's linux-next merge of the drbd tree got a conflict in
> mm/page-writeback.c between commit
> 42bd225c0ba7c95af39293d39a950c48e7e5cb23 (""laptop-mode: Make flushes
> per-device" fix") from the block tree and commit
> e913fc825dc685a444cb4c1d0f9d32f372f59861 ("writeback: fix WB_SYNC_NONE
> writeback from umount") from the drbd tree (via its merge of the block
> tree).
> 
> I used the next-20100517 version of the block tree today (because the
> above conflict was not resolved correctly in the block tree and caused a
> build failure), so I will also use the next-20100517 version of the drbd
> tree for today.
> 
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
