Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0HCJtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:49:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49872 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0HCJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:49:45 -0400
Date: Tue, 3 Aug 2010 11:49:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100803094940.GC31096@basil.fritz.box>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <87tyncds89.fsf@basil.nowhere.org>
 <20100803092823.GA5324@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803092823.GA5324@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 07:28:23PM +1000, Nick Piggin wrote:
> OK, vfs-scale-working branch now has commits to enable rcu-walk aware
> d_revalidate, permission, and check_acl in the filesystems, and
> implements a basic rcu-walk aware scheme for generic/posix acls and

Cool. I was just looking at that.

> I was under the impression that ACLs on directories are not that common,
> so maybe this is as far as we need to go for now anyway.

Yes it shouldn't be common normally. I think the common case for distros
is just a few ACLs in /dev. Of course you never know for 
specific end user workloads.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
