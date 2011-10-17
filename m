Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1JQDJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 23:09:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35077 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab1JQDJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 23:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <CANsGZ6Zs0sPMqcToGpw8H1vLcAewyj4aii+iy0V9oyhk7RqzjA@mail.gmail.com>
References: <201110122012.33767.pluto@agmk.net> <alpine.LSU.2.00.1110131547550.1346@sister.anvils>
 <CA+55aFyTif3k0-wb+1zS8b+hKT13pL0T_qtVzAz2HW5U9=yoMg@mail.gmail.com> <CANsGZ6Zs0sPMqcToGpw8H1vLcAewyj4aii+iy0V9oyhk7RqzjA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Oct 2011 20:09:12 -0700
X-Google-Sender-Auth: Bm3vg8Qnqi5X8P-p3RkicvWxQOk
Message-ID: <CA+55aFwfkiH7NN18ve2y0PUK8UobagHfpTJ4QoZSL1KLLUMFTw@mail.gmail.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
To: Hugh Dickins <hughd@google.com>
Cc: Pawel Sikora <pluto@agmk.net>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 8:02 PM, Hugh Dickins <hughd@google.com> wrote:
> I've not read through and digested Andrea's reply yet, but I'd say
> this is not something we need to rush into 3.1 at the last moment,
> before it's been fully considered: the bug here is hard to hit,
> ancient, made more likely in 2.6.35 by compaction and in 2.6.38 by
> THP's reliance on compaction, but not a regression in 3.1 at all - let
> it wait until stable.

Ok, thanks. Just wanted to check.

                     Linus
