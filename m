Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1FITk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:40:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559Ab1FITkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110609123220.6afb9d0f.akpm@linux-foundation.org>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org> <20110609134947.GD13242@shadowen.org>
 <20110609123220.6afb9d0f.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jun 2011 12:40:01 -0700
Message-ID: <BANLkTimTyYp1P4qd8awvsq6PVZn1TQ5A-Q@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 12:32 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> If the implementation is slow or buggy then the appropriate action is
> to speed it up and to fix the bugs, so these are just non-arguments,
> IMO.

Umm.

"userspace filesystem"?

The problem is right there. Always has been. People who think that
userspace filesystems are realistic for anything but toys are just
misguided.

fuse works fine if the thing being exported is some random low-use
interface to a fundamentally slow device. But for something like your
root filesystem? Nope. Not going to happen.

So Andrew, I think that arguing that something _can_ be done with
fuse, and thus _should_ be done with fuse is just ridiculous. That's
like saying you should do a microkernel - it may sound nice on paper,
but it's a damn stupid idea for people who care more about some idea
than they care about reality.

                          Linus
