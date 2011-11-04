Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1KDIM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:12:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:49498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1KDIM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:12:27 -0400
Message-ID: <4EB39E63.9020804@kernel.dk>
Date: Fri, 04 Nov 2011 09:12:19 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
References: <4EB2BC88.3070105@suse.cz> <20111103161436.GJ4417@google.com> <20111103162634.GK4417@google.com> <4EB2D441.9040708@kernel.dk> <20111103211253.GO4417@google.com>
In-Reply-To: <20111103211253.GO4417@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-03 22:12, Tejun Heo wrote:
> On Thu, Nov 03, 2011 at 06:49:53PM +0100, Jens Axboe wrote:
>>> Fix it by making blk_cleanup_queue() check whether q->elevator is set
>>> up before invoking blk_drain_queue.
>>
>> Thanks, glad this got caught before the merge...
> 
> Heh, yeah, definitely, and just to be paranoid, this whole thing is
> for the next merge window.

Ehm, what parts? If the bug is in for-next, things are queued up for
_this_ merge window.

-- 
Jens Axboe

