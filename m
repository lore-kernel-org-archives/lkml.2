Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0KUEuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 23:50:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38409
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab0KUEue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 23:50:34 -0500
Date: Sat, 20 Nov 2010 20:50:59 -0800 (PST)
Message-Id: <20101120.205059.193725921.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
        libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de
Subject: Re: [PATCH 00/62] drivers/net: Use static const
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 20 Nov 2010 18:38:01 -0800

> Using static const generally increases object text and decreases data size.
> It also generally decreases overall object size.

Joe, I'm going to be frank and say that I'm not going to review and
apply such a large chunk of networking patches.

Seperation is cool, splitting up patches is cool to make review
perhaps easier and more distributed.

But in the end _I_ have to purge through these things and submitting
so many patches at a time, multiple times per release cycle, abuses me
as a resource.

Yes, Linus has to deal with perhaps a hundred patches, or more, at a
time from Andrew Morton during the merge window.  But he has to do
that _ONE_ time each release.  You crap large sets of patches on me
multiple times per release cycle.

This cannot continue, my sanity depends upon it.

You therefore cannot funnel 40, 50, 60, or more patches at me at a
time, multiple times per release.  It severely negatively effects my
mood, because it makes me feel like me head is below water again
_RIGHT_ after I've worked all damn week to finally made the networking
patch backlog sane again.

You also make this more difficult for me by not using GIT.  Even
with patchwork helping me significantly, it's still a lot of work
to apply large sets of patches.  If I had to take in John Linville's
wireless stuff without GIT I'd be banging my head on a wall.

And these incessant huge patch bombs also take time away from me for
the things I'd like to at least occiasionally work on that involve
more intellect than monkeying around with such mindless patches.

Thanks for your understanding.  Feel free to submit this stuff in
smaller chunks, say ~10 patches at a time.
