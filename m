Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab0HELtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:49:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab0HELtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:49:18 -0400
Date: Thu, 5 Aug 2010 13:49:15 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Transparent Hugepage Support #29
Message-ID: <20100805114915.GA25503@random.random>
References: <20100803135615.GG6071@random.random>
 <201008040815.02368.edt@aei.ca>
 <20100804124442.GO6071@random.random>
 <201008050727.25253.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008050727.25253.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:27:24AM -0400, Ed Tomlinson wrote:
> On a tree with:
> 
> commit 9d9cec888c3c4a2d5b5f01c3f3984fc4bc602681
> Merge: dd6c927 9edd35f
> Author: Ed <edt@aei.ca>
> Date:   Wed Aug 4 15:18:53 2010 -0400
> 
>     Merge branch 'vfs-scale-working' of git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin into vfs-scaling
> 
> merged on top of
> 
> commit 9fe6206f400646a2322096b56c59891d530e8d51
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Aug 1 15:11:14 2010 -0700
> 
>     Linux 2.6.35

Well I didn't realize you also merged 2.6.35 on top of it. This is no
standard tree, so I suggest you to checkout -f origin/master of Nick's
tree until he updates to 2.6.35 himself (then I can port to it).
