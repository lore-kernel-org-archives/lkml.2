Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab0HDMos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab0HDMoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:44:46 -0400
Date: Wed, 4 Aug 2010 14:44:42 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Transparent Hugepage Support #29
Message-ID: <20100804124442.GO6071@random.random>
References: <20100803135615.GG6071@random.random>
 <201008040815.02368.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008040815.02368.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ed,

On Wed, Aug 04, 2010 at 08:15:02AM -0400, Ed Tomlinson wrote:
> Andrea,
> 
> I have been tracking & testing this for a while.   It looks very much like Linus wants to merge (or a big chunk of it):
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working
> 
> When I pull an aa-29 on top of this there is one conflict in vmscan.c that git cannot resolve.
> It would be really nice to have a version of the THS patchs that can be tested with the vfs scaling
> tree.

please try:

zcat transparent-hugepage-29.gz  |patch -p1

It didn't spawn rejects here, maybe something's wrong in some
intra-patch or git is too picky. If it doesn't build let me know and I
will look into it, thanks!

Andrea
