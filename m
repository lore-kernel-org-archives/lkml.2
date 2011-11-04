Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1KDO0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:26:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36980 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab1KDO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <4EB39E63.9020804@kernel.dk>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
	<4EB2D441.9040708@kernel.dk>
	<20111103211253.GO4417@google.com>
	<4EB39E63.9020804@kernel.dk>
Date: Fri, 4 Nov 2011 07:26:27 -0700
X-Google-Sender-Auth: KHuItdHzOWWsAXiLRRKhpeTxIiA
Message-ID: <CAOS58YM-6v2nriMv8izhePD04YiJe0s7wqwWw=Dc9w-4er_McA@mail.gmail.com>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jslaby@suse.cz>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 4, 2011 at 1:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> Heh, yeah, definitely, and just to be paranoid, this whole thing is
>> for the next merge window.
>
> Ehm, what parts? If the bug is in for-next, things are queued up for
> _this_ merge window.

So, we had four patchsets - the original drain improvements, updates
to drain improvements, cfq locking cleanup, and cfq api cleanup.
Currently, the first one is in block tree but the other three are not.
I was thinking all four were going mainline in the next merge window.

Hmmm... yeah, the first and second patchsets kinda go together but
well the first one definitely is pretty good bug fix without others,
so I guess that split isn't too bad either. Alright, no objection.

Thanks.

-- 
tejun
