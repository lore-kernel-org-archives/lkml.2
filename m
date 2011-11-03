Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1KCVTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:19:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60199 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1KCVTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:19:47 -0400
Date: Thu, 3 Nov 2011 14:12:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jslaby@suse.cz>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Message-ID: <20111103211253.GO4417@google.com>
References: <4EB2BC88.3070105@suse.cz>
 <20111103161436.GJ4417@google.com>
 <20111103162634.GK4417@google.com>
 <4EB2D441.9040708@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2D441.9040708@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 06:49:53PM +0100, Jens Axboe wrote:
> > Fix it by making blk_cleanup_queue() check whether q->elevator is set
> > up before invoking blk_drain_queue.
> 
> Thanks, glad this got caught before the merge...

Heh, yeah, definitely, and just to be paranoid, this whole thing is
for the next merge window.

Thanks.

-- 
tejun
