Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1LQI2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 03:28:45 -0500
Received: from xenon.siliconoak.com ([89.145.97.167]:59149 "EHLO
	xenon.siliconoak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1LQI2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 03:28:38 -0500
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Dec 2011 03:28:38 EST
Date: Sat, 17 Dec 2011 08:20:48 +0000
From: Nick Holloway <Nick.Holloway@pyrites.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
Message-ID: <20111217082048.GA11790@pyrites.org.uk>
References: <i82GC-j4-7@gated-at.bofh.it>
 <i89I5-3Bp-11@gated-at.bofh.it>
 <i8oQP-4s2-29@gated-at.bofh.it>
 <i8rOG-XY-7@gated-at.bofh.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Newsgroups: linux.kernel
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>   git cat-file commit 2240a7bb479c |
>        awk '/^mergetag /,/^$/ { print }' |
>        sed 's/^mergetag//' |
>        sed 's/^ //'
>
> (ok, that can almost certainly be done smarter,

Forfilling your prediction that it could be smarter, here is the same
in a single sed invocation:

    git cat-file commit 2240a7bb479c | 
	sed -rn '/^mergetag /,/^$/{s/^(mergetag)? //p}'

I don't expect anyone cares though...

-- 
 `O O'  | Nick.Holloway@pyrites.org.uk
// ^ \\ | http://www.pyrites.org.uk/
