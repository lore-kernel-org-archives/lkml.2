Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0IDHRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 03:17:51 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49607 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab0IDHRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 03:17:50 -0400
Message-ID: <4C81F29C.7030600@kernel.dk>
Date: Sat, 04 Sep 2010 09:17:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Martin Pirker <lkml.collector@gmail.com>,
        Dan Carpenter <error27.lkml@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>, mjg@redhat.com
Subject: Re: 2.6.35-rc5 inconsistent lock state
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>	<201007142304.48660.rjw@sisk.pl>	<AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>	<4C42099C.3070708@kernel.dk>	<AANLkTik5VjJsdWhRcxCGCoayMTZRUwTNUzWNpqYxjzLs@mail.gmail.com> <20100903093755.6fa13d4f@schatten.dmk.lab>
In-Reply-To: <20100903093755.6fa13d4f@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 09:37 AM, Florian Mickler wrote:
> On Mon, 19 Jul 2010 21:48:04 +0200
> Martin Pirker <lkml.collector@gmail.com> wrote:
> 
>> On Sat, Jul 17, 2010 at 9:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> I posted a patch for this the other day, but I just now notice
>>> that it was a private list of CC addresses.
>>>
>>> Can anyone try this completed untested patch?
>>
>> [sorry Jens for my first failed test attempt, my idiocy...]
>>
>> applied to 2.6.35-rc5 -> error message so far not seen again.
>> about functionality, well, HD spin up control via laptop_mode I cannot
>> say, I've a SSD...
>>
>> HTH,
>> Martin
> 
> Is this patch on route to mainline? Or did this get fixed some other
> way?

The lock is bh safe in mainline now, the patch should not be
needed. Are you still seeing the bad behaviour?

-- 
Jens Axboe

