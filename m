Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0KJSzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:55:13 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:34951 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754305Ab0KJSzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:55:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABd52kxLd/sX/2dsb2JhbAAHgzLNSJEJgSKDNXMEhFqLdw
X-IronPort-AV: E=Sophos;i="4.59,179,1288584000"; 
   d="scan'208";a="82133355"
Message-ID: <4CDAEA8A.7090002@teksavvy.com>
Date: Wed, 10 Nov 2010 13:55:06 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        dave b <db.pub.mail@gmail.com>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Jesper Juhl <jj@chaosbits.net>, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
References: <20101105014334.GF13830@dastard>	<E1PELiI-0001Pj-8g@approx.mit.edu>	<AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>	<4CD696B4.6070002@kernel.dk>	<AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>	<20101110013255.GR2715@dastard>	<AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>	<AANLkTinYZ2wPeeunFv4Ljm+D9SDLbgzTVmw_P9KQdK16@mail.gmail.com>	<AANLkTik1zyrP5DBGC+MmSKF2Eeep3fSu=-8TdOY8BTJj@mail.gmail.com> <AANLkTi=8uwjAqSmMWbAwX1gGbjS8Q8Rh1mPu7RArdLJt@mail.gmail.com>
In-Reply-To: <AANLkTi=8uwjAqSmMWbAwX1gGbjS8Q8Rh1mPu7RArdLJt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-10 12:10 PM, Alexey Dobriyan wrote:
> On Wed, Nov 10, 2010 at 6:55 PM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> On Wed, Nov 10, 2010 at 8:46 AM, Alexey Dobriyan<adobriyan@gmail.com>  wrote:
>>> Those of us, who did (without UPS), will never do it again.

I've used ext2 and ext3 extensively on all of the boxes here,
every since each first became available.   I developed Linux IDE,
the first IDE DMA, lots of custom storage drivers, and more recently
worked on libata drivers.  This meant a LOT of sudden and catastrophic
system failures, as the bugs and other kinks were worked on.

Never lost a nibble.  Totally, utterly reliable stuff for everyday use.
*WITH* the write-caches all enabled on all of the drives, too.

Sure, sudden power-failures could have a better chance of corrupting data,
but those are really rare, and the few that have happened were again non-events 
here.

That's the difference between theory and practice.

Cheers
-ml
