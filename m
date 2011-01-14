Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab1ANBcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:32:01 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:58676 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1ANBbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:31:55 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH] fs: Work around NFS wreckage
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
In-Reply-To: <20110113151736.GW24920@pengutronix.de>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6> <8952.1294927845@jrobl> <20110113151736.GW24920@pengutronix.de>
Date: Fri, 14 Jan 2011 10:30:44 +0900
Message-ID: <6610.1294968644@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Uwe Kleine-Knig:
> > With this patch, can you unmount it cleanly?
> > It skips incrementing d_count for both dentries.
> > Do we need at least one?
> If you tell me how to test that, I volunteer to try.
> Something involving pivot_root?

For example,
# mount host:/dir /nfs
# chroot /nfs
# umount /nfs

It is ok if /nfs is empty.


J. R. Okajima
