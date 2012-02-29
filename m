Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031100Ab2B2O5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:57:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031018Ab2B2O5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:57:21 -0500
Date: Wed, 29 Feb 2012 15:57:11 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] block: fix __blkdev_get and add_disk race condition
Message-ID: <20120229145710.GB20516@redhat.com>
References: <20120222165948.GA12961@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222165948.GA12961@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 05:59:49PM +0100, Stanislaw Gruszka wrote:
> I use the script to verify patch fixing oops in sd_revalidate_disk
> http://marc.info/?l=linux-scsi&m=132935572512352&w=2
> Without Jun'ichi Nomura patch titled "Fix NULL pointer dereference in
> sd_revalidate_disk" or this one, script easily crash kernel within
> a few seconds.

Jens could you pick up both patches for 3.3 ? Both are actually a -stable
fixes, despite they are not marked so, perhaps we should repost patches
with that mark?

Thanks
Stanislaw
