Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab0HEL6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:58:12 -0400
Received: from mail001.aei.ca ([206.123.6.130]:58357 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925Ab0HEL6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:58:10 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Transparent Hugepage Support #29
Date: Thu, 5 Aug 2010 07:57:52 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-crc+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>
References: <20100803135615.GG6071@random.random> <201008050727.25253.edt@aei.ca> <20100805114915.GA25503@random.random>
In-Reply-To: <20100805114915.GA25503@random.random>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008050758.04918.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 August 2010 07:49:15 Andrea Arcangeli wrote:
> On Thu, Aug 05, 2010 at 07:27:24AM -0400, Ed Tomlinson wrote:
> > On a tree with:
> > 
> > commit 9d9cec888c3c4a2d5b5f01c3f3984fc4bc602681
> > Merge: dd6c927 9edd35f
> > Author: Ed <edt@aei.ca>
> > Date:   Wed Aug 4 15:18:53 2010 -0400
> > 
> >     Merge branch 'vfs-scale-working' of git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin into vfs-scaling
> > 
> > merged on top of
> > 
> > commit 9fe6206f400646a2322096b56c59891d530e8d51
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Sun Aug 1 15:11:14 2010 -0700
> > 
> >     Linux 2.6.35
> 
> Well I didn't realize you also merged 2.6.35 on top of it. This is no
> standard tree, so I suggest you to checkout -f origin/master of Nick's
> tree until he updates to 2.6.35 himself (then I can port to it).

Nick,

Any chance of the above happening?  I'd love to test both the vfs scaling changes
and Andrea's much improved hugepage support together on top of .35

TIA
Ed Tomlinson
