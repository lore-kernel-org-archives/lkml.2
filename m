Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2BHW2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:28:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37854 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab2BHW2r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:28:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAG4TOxPwcdw+CwyczAVXBqovpECVj8ad+RsraqmchuQdM2bCXw@mail.gmail.com>
References: <1311923731.7845.25.camel@edumazet-laptop>
	<1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com>
	<CAJZOPZJtXGq36Hx5BQAc2Q7znErJ-Uaiqs-DaJQ=jCSy49uTiQ@mail.gmail.com>
	<CAG4TOxPwcdw+CwyczAVXBqovpECVj8ad+RsraqmchuQdM2bCXw@mail.gmail.com>
Date: Thu, 9 Feb 2012 00:28:46 +0200
Message-ID: <CAJZOPZJs6KpcRTc2HH0rEiParY=ZQUkXZmoUzh2OwZw9+rDjsQ@mail.gmail.com>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Sean Hefty <sean.hefty@intel.com>,
        linux-rdma@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 11:35 PM, Roland Dreier <roland@kernel.org> wrote:
> On Wed, Feb 8, 2012 at 1:26 PM, Or Gerlitz <or.gerlitz@gmail.com> wrote:

>> [...] This means that the window of time when features are actually accepted
>> into your tree is kind of very limited. Would it be possible to
>> maintain two branches: for-next and (say) rc-fixes, such that
>> practically patches are reviewed/accepted to for-next at almost all times?

>> BTW I see that networking and scsi maintainers use two trees (net/net-next)
>> and (scsi-misc/scsi-rc-fixes), maybe it would be eaiser for you go this way?

> It's not really an issue of not having a tree to put things into.  It's
> more that the window when I actually review major things is not
> as big as perhaps it should be.

> So I generally try to get fixes in expeditiously because they're
> easy to deal with, whereas I only dedicate time to merging bigger
> things when I feel the pressure of the impending merge window.

but bigger things need bigger time to deal with... but even before we
address that -

> I do usually have some small patches that are fine for the next window
> but which I have only marked "to apply" in my mailbox, which it
> might be a good idea to apply sooner so they get more -next tree coverage.

Yep, having a branch where patches you accept are applied sooner
rather then later,
will be a little but surely nice && important step in the right
direction... it would be great to have this, could you make that
happen?

Also, to except for patches which you reviewed and willing to accept,
it happens that Sean Hefty who is also a maintainer, reviews patches
and provides his reviewed-by signature. I would say such patches could
(should) go to that branch as well and not wait to the pressure of the
impending merge window.

How does all this sound?

Or.
