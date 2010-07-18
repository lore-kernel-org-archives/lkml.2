Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab0GRR5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 13:57:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39023 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab0GRR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 13:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TBmkhRcn8S2c1EsvGgTtRa0ieuJ4Kv3UhJj+Cdkb11m0RTR/+qVdngGQwEv6Bscra9
         RLMUX5ixGUT1dKeVgor92zNSkRHVlTh+FDimeWgpaq8I6kiikncJduqPt4yPi1dd1h60
         ZXmP0rr2O5HvxQWZaeUvFcNAqhqibmqEWhwi0=
MIME-Version: 1.0
In-Reply-To: <4C42099C.3070708@kernel.dk>
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
	<201007142304.48660.rjw@sisk.pl>
	<AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>
	<4C42099C.3070708@kernel.dk>
Date: Sun, 18 Jul 2010 19:56:58 +0200
Message-ID: <AANLkTikk_UNVoo9CC9DhCSwiI5mEB3j1RrXqqOPdei1L@mail.gmail.com>
Subject: Re: 2.6.35-rc5 inconsistent lock state
From: Martin Pirker <lkml.collector@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 9:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> Can anyone try this completed untested patch?
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5ab3ac2..a108b8e 100644
....

/usr/src/linux-2.6.35-rc5 # patch -p1 <jens.patch
patching file block/blk-core.c
Hunk #1 FAILED at 451.
Hunk #2 FAILED at 515.
2 out of 2 hunks FAILED -- saving rejects to file block/blk-core.c.rej
patching file include/linux/backing-dev.h
Hunk #1 FAILED at 84.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/backing-dev.h.rej
patching file include/linux/writeback.h
patching file mm/page-writeback.c
Hunk #1 FAILED at 698.
Hunk #2 FAILED at 719.
Hunk #3 FAILED at 739.
3 out of 3 hunks FAILED -- saving rejects to file mm/page-writeback.c.rej


ummmm.... help?

Martin
