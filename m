Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0JNTpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:45:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55193 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0JNTpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:45:34 -0400
Date: Thu, 14 Oct 2010 21:45:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, agruen@suse.de, jengelh@medozas.de,
        davem@davemloft.net, andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
Message-ID: <20101014194529.GB17472@basil.fritz.box>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 03:34:52PM -0400, Eric Paris wrote:
> A patch was posted a bit ago by agruen which made a change to
> include/linux/types.h changing aligned_u64 to __aligned_u64 and exposing
> this new type to userspace.

I just ran into this problem (aligned_u64 not being exposed to user space),
so yes I definitely welcome that change.


> 
> http://marc.info/?l=linux-kernel&m=128316627912457&w=2
> 
> Everyone seemed to agree the patch was a good idea and was correct.  At
> the moment this change only really affects network code, but I would
> very much like to make use of this change in the notification tree.
> Dave Miller did not apply the patch because "Someone has to first add
> the types to linux/types.h, and that doesn't go through my tree."

When in doubt send it to Andrew I guess. I see you already did.

-Andi

