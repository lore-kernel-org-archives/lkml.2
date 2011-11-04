Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1KDOaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:30:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab1KDOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <4EB3F680.1070309@kernel.dk>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
	<4EB2D441.9040708@kernel.dk>
	<20111103211253.GO4417@google.com>
	<4EB39E63.9020804@kernel.dk>
	<CAOS58YM-6v2nriMv8izhePD04YiJe0s7wqwWw=Dc9w-4er_McA@mail.gmail.com>
	<4EB3F680.1070309@kernel.dk>
Date: Fri, 4 Nov 2011 07:30:05 -0700
X-Google-Sender-Auth: MdnCKU66wQJgoRQExkiZJOLaf2I
Message-ID: <CAOS58YPMpbH_ex97g25G1375HPrphdXzuOe=DR78b4S07nJugw@mail.gmail.com>
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

On Fri, Nov 4, 2011 at 7:28 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> Hmmm... yeah, the first and second patchsets kinda go together but
>> well the first one definitely is pretty good bug fix without others,
>> so I guess that split isn't too bad either. Alright, no objection.
>
> OK, I'll push off what I have now and then we can queue #2 up shortly. I
> would probably prefer pushing the cfq locking cleanup to 3.3 to get some
> more testing time on that, but it all depends on what your level of
> confidence in it is?

Not that confident. Those definitely belong to the next window.

Thank you.

-- 
tejun
