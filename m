Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1I1Azq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:55:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60971 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1I1Azp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:55:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110928004722.GA27421@kernel.dk>
References: <201109221318.p8MDIXPP020015@pentland.suse.de> <20110928004722.GA27421@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Sep 2011 17:55:24 -0700
X-Google-Sender-Auth: Z9qGj9r07CCoI9zsgBMZZt1GJXQ
Message-ID: <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 5:47 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Do we have acks from the people who saw this oops, that this really does
> fix it for them? I ask since this fix is vastly cleaner than the other
> patch floating around, so I'd much rather pull this one in.

I don't think I can't test it, since it seems to be some hard-to-hit
race condition. It certainly doesn't seem to happen all the time -
today was the first time I've seen it on one of my computers.

But if you forward the actual patch to me (the one I see on lkml seems
to be broken and doesn't compile cleanly because it's assiging a
structure to a pointer), I'll try it out anyway.

                     Linus
