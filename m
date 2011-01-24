Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1AXBcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 20:32:01 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:60077 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1AXBcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 20:32:00 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 2/2] block: clear ro on fd detach fd is bound
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20110122142303.GD6160@htj.dyndns.org>
References: <23846.1295615979@jrobl> <20110122142234.GC6160@htj.dyndns.org> <20110122142303.GD6160@htj.dyndns.org>
Date: Mon, 24 Jan 2011 10:28:08 +0900
Message-ID: <7965.1295832488@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tejun Heo:
> Commit 75f1dc0d (block: check bdev_read_only() from blkdev_get())
> enforced bdev_read_only() check during blkdev_get().  This had an
> unfortunate side effect on loop because loop didn't clear ro flag on
> fd detach, so once a loop device was used ro, it can't be used for rw
> at all.
>
> Fix it by clearing ro flag on fd detach.

Tested and succeeded, thanx.


J. R. Okajima
