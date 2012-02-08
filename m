Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2BHVfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:35:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57642 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2BHVfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:35:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAJZOPZJtXGq36Hx5BQAc2Q7znErJ-Uaiqs-DaJQ=jCSy49uTiQ@mail.gmail.com>
References: <1311923731.7845.25.camel@edumazet-laptop> <1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com> <CAJZOPZJtXGq36Hx5BQAc2Q7znErJ-Uaiqs-DaJQ=jCSy49uTiQ@mail.gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 8 Feb 2012 13:35:16 -0800
X-Google-Sender-Auth: Cgoa0Th0qDzHx6dYqpIuU0IImnE
Message-ID: <CAG4TOxPwcdw+CwyczAVXBqovpECVj8ad+RsraqmchuQdM2bCXw@mail.gmail.com>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Sean Hefty <sean.hefty@intel.com>,
        linux-rdma@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 1:26 PM, Or Gerlitz <or.gerlitz@gmail.com> wrote:
> I noted that you typically use the for-next branch of the infiniband
> tree for fixes during
> the 1 < kernN-rc < (say) 6 time and for features during (kernN-rc > 6)
> till kern(N+1)-rc1
>
> This means that the window of time when features are actually accepted
> into your tree is kind of very limited. Would it be possible to
> maintain two branches: for-next and (say) rc-fixes, such that
> practically patches are reviewed/accepted to for-next at almost all
> times?
>
> BTW I see that networking and scsi maintainers use two trees
> (net/net-next) and (scsi-misc/scsi-rc-fixes), maybe it would be eaiser
> for you go this way?

It's not really an issue of not having a tree to put things into.  It's
more that the window when I actually review major things is not
as big as perhaps it should be.

So I generally try to get fixes in expeditiously because they're
easy to deal with, whereas I only dedicate time to merging bigger
things when I feel the pressure of the impending merge window.

I do usually have some small patches that are fine for the next window
but which I have only marked "to apply" in my mailbox, which it
might be a good idea to apply sooner so they get more -next tree
coverage.

 - R.
