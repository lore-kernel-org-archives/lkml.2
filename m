Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1I1CCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:02:14 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:52829
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1I1CCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:02:13 -0400
Message-ID: <4E828020.4060205@kernel.dk>
Date: Tue, 27 Sep 2011 20:02:08 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
References: <201109221318.p8MDIXPP020015@pentland.suse.de> <20110928004722.GA27421@kernel.dk> <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com> <4E82751C.9050908@kernel.dk> <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
In-Reply-To: <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-27 19:59, Linus Torvalds wrote:
> On Tue, Sep 27, 2011 at 6:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> But if you forward the actual patch to me (the one I see on lkml seems
>>> to be broken and doesn't compile cleanly because it's assiging a
>>> structure to a pointer), I'll try it out anyway.
>>
>> Thanks, that would be great. It's inlined below.
> 
> Well, I did several USB eject events, and nothing bad happened.
> 
> But as mentioned, I don't think that means much. Have you tried this
> with slub debugging and poisoning? It might be worth some extra
> testing that way.

I'm traveling at the moment, and don't have a stick handy here. I'll try
it tomorrow morning, before and after (both with pagealloc etc debuggin
on).

-- 
Jens Axboe

