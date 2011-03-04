Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1CDPZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:25:17 -0500
Received: from mail.deathmatch.net ([72.66.92.28]:3266 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab1CDPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:25:12 -0500
Date: Fri, 4 Mar 2011 10:24:47 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: omfs fixes
Message-ID: <20110304152447.GA14198@hash.localnet>
References: <20110303032454.GI22723@ZenIV.linux.org.uk> <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com> <20110303060352.GK22723@ZenIV.linux.org.uk> <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com> <87tyfk7x0c.fsf@devron.myhome.or.jp> <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com> <87lj0v9984.fsf@devron.myhome.or.jp> <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com> <20110303225702.GQ22723@ZenIV.linux.org.uk> <20110304065542.GT22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304065542.GT22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 06:55:42AM +0000, Al Viro wrote:
> I've pushed fixes for (b), (c) and (d) into #i_nlink and I think that (a)
> needs to be dealt with as well, but that one is less nasty.  Bob, do you
> prefer that to go through your tree or should it go straight to Linus?
> It's in git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ i_nlink,

Looks great, thanks for the review.  I'll go ahead and take them through
my tree after a quick run through the test harness.

-- 
Bob Copeland %% www.bobcopeland.com

