Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0F2MFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:05:53 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58447 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab0F2MFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:05:51 -0400
Message-ID: <4C29E1A0.7070601@kernel.dk>
Date: Tue, 29 Jun 2010 14:05:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: xiaosuo@gmail.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] splice fixes
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu> <4C29D5B9.9040401@kernel.dk> <E1OTZYn-0008Qk-El@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OTZYn-0008Qk-El@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-29 14:05, Miklos Szeredi wrote:
> On Tue, 29 Jun 2010, Jens Axboe wrote:
>> On 2010-06-29 13:08, Miklos Szeredi wrote:
>>> These patches fix bugs that affect real-world users of splice(2) and
>>> sendfile(2) interfaces.
>>>
>>> Not sure if some or all of them are appropriate for 2.6.35 and/or
>>> -stable?
>>
>> I think that 1-2 should go into 2.6.35 directly, and 3 for .36 with
>> a stable backport as well. Agree?
> 
> Yes, sounds good.

Good, that is what I queued up. I haven't pushed out the updated
for-linus yet, since I asked Linus to pull it this morning.

-- 
Jens Axboe

