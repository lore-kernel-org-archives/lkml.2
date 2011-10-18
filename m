Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab1JRNmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:42:01 -0400
Received: from lucidpixels.com ([72.73.18.11]:49501 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab1JRNmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:42:00 -0400
Date: Tue, 18 Oct 2011 09:42:00 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Hugh Dickins <hughd@google.com>
cc: Pawel Sikora <pluto@agmk.net>, arekm@pld-linux.org,
        Anders Ossowicki <aowi@novozymes.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 3.1-rc9: BUG: soft lockup in find_get_pages+0x4e/0x140
In-Reply-To: <alpine.LSU.2.00.1110172036300.7358@sister.anvils>
Message-ID: <alpine.DEB.2.02.1110180806480.7942@p34.internal.lan>
References: <alpine.DEB.2.02.1110152003210.26507@p34.internal.lan> <alpine.LSU.2.00.1110172036300.7358@sister.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Oct 2011, Hugh Dickins wrote:

> On Sat, 15 Oct 2011, Justin Piszcz wrote:
>>
>> With 3.1-rc9 during a filesystem dump, this occurred, I thought a previous
>> patch fixed this but it did not, it occurs MUCH less (first time in a couple
>> of weeks) but the problem still occurs.
>
> Shaohua's nr_skip patch fixed, or at least worked around, the error I
> introduced there in 3.1-rc1.  But now you're finding a similar problem
> still in 3.1-rc9: that confirms what you and others already reported,
> that something like it occurs even in 3.0 without my bug.

Thanks,

Patch applied:

# patch -p1 < /tmp/memory_patch.patch
patching file mm/filemap.c
patching file mm/memcontrol.c

Now running 3.1-rc9 + this patch + re-enabled frame pointers.

Justin.

